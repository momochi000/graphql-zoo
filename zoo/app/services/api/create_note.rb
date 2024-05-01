module Api
  module CreateNote
    class << self
      def execute(create_note_args)
        if create_note_args[:note_attachment].present?
          if !create_note_args[:note_attachment][:notable_type].present? || !create_note_args[:note_attachment][:notable_id].present?
            # TODO: Create an appropriate error
            raise Exception.new "When attaching a note to something, both the type and ID must be present"
          end
          note_attachment_params = {
            notable_type: create_note_args[:note_attachment][:notable_type],
            notable_id: create_note_args[:note_attachment][:notable_id],
          }
          create_note_args.delete(:note_attachment)
          note = ::Note.create(**create_note_args, **note_attachment_params)
          raise Exception.new "Error creating note: #{note.errors.to_hash}" unless note.persisted?

        else
          note = ::Note.create(**create_note_args)
          raise Exception.new "Error creating note: #{note.errors.to_hash}" unless note.persisted?
        end
        note
      end
    end
  end
end
