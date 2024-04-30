require 'rails_helper'

describe "noteCreate graphql query root field" do
  subject { ZooSchema.execute(query_string).to_h }

  context "with an employee present in the system" do
    let!(:employee) { Employee.create(role: :caretaker, pii_attributes: {first_name: 'Testy', last_name: 'McTesterson'})}
    let!(:habitat) { Habitat.create(name: "savannah") }

    context "Employee creating a note" do
      let(:note_content) { "test note" }
      let(:note_attachment_args) {""}
      let(:query_string) {
        <<-GRAPHQL
          mutation {
            noteCreate(input:{
              noteInput:{
                content: "#{note_content}"
                employeeId: #{employee.id}
                #{note_attachment_args}
              }
            }) {
              note {
                id
                content
              }
            }
          }
        GRAPHQL
      }
      it "creates the note" do
        expect {subject}.to change {Note.count }.by(1)
        output = subject["data"]["noteCreate"]["note"]
        expect(output["content"]).to eq note_content
      end
      it "attaches the note to the employee" do
        expect {subject}.to change{ employee.reload.notes.count }.by(1)
      end

      context "which attaches to an existing animal" do
        let!(:animal) { Animal.create(name: 'drake', species: 'dragon', habitat: habitat) }
        let(:note_attachment_args) {
          <<-GRAPHQL
            noteAttachment:{
              notableType: ANIMAL
              notableId: #{animal.id}
            }
          GRAPHQL
        }

        it "creates the note" do
          expect {subject}.to change {Note.count }.by(1)
          output = subject["data"]["noteCreate"]["note"]
          expect(output["content"]).to eq note_content
        end
        it "attaches the note to the employee" do
          expect {subject}.to change{ employee.reload.notes.count }.by(1)
        end
        it "attaches the note to the animal" do
          expect {subject}.to change{ animal.reload.notes.count }.by(1)
        end
        it "doesn't attach a note to the habitat" do
          expect {subject}.not_to change{ habitat.reload.notes.count }
        end
      end

      context "which attaches to an existing habitat" do
        let(:note_attachment_args) {
          <<-GRAPHQL
            noteAttachment:{
              notableType: HABITAT
              notableId: #{habitat.id}
            }
          GRAPHQL
        }

        it "creates the note" do
          expect {subject}.to change {Note.count }.by(1)
          output = subject["data"]["noteCreate"]["note"]
          expect(output["content"]).to eq note_content
        end
        it "attaches the note to the employee" do
          expect {subject}.to change{ employee.reload.notes.count }.by(1)
        end
        it "attaches the note to the habitat" do
          expect {subject}.to change{ habitat.reload.notes.count }.by(1)
        end
      end
    end
  end
end
