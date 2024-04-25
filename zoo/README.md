# README

Ruby version: 3.3

System dependencies: docker

* How to run the test suite

## Problem statement, instructions, discussion, and notes

Overview

Develop a Ruby on Rails application to manage animals, their care, and habitats in a zoo. The system should track different types of animals, their diets, and habitats, and manage employee records securely.

Requirements

    Enum: Use enums to define the status of animals (e.g., `healthy`, `sick`, `injured`) and employee roles (e.g., `vet`, `caretaker`, `manager`). This will facilitate easy status updates and role assignments within the system.

    Array Type: Utilize array types to store multiple values where applicable, such as a list of daily feeding times for animals or a list of tasks for employees.

    JSON Blob: Use JSON blobs to store flexible data, such as dietary requirements for each animal (which include food type, quantity, etc) and habitat preferences (temperature range, necessary features like water bodies for aquatic animals, trees for climbing animals, sand for desert animals).

    Encrypt PII: Ensure the encryption of Personally Identifiable Information (PII) for employees, such as first name, last name, email, and phone number.

    Accepts Nested Attributes in GraphQL Mutation: Design the GraphQL API to allow for nested attributes in mutations.

    This app will run on a local, air-gapped intranet, so authentication is not necessary.

    This will start as a small app to handle only 40-75 animals, but if the zoo likes it, it would like to know how to scale it to hundreds of zoos, thousands of animals, and the API would need to handle hundreds of thousands of concurrent users. Please diagram the app infrastructure for scale.

Coding Project Tasks

    Model Setup: Create models for `Animal`, `Habitat`, `Employee`, and `Note` with the specified associations and fields. Include validations to ensure data integrity.

    Enums and Array Types: Define enums for animal status and employee roles. Use array types for storing feeding times and tasks.

    JSON Storage: Implement JSON blobs for dietary requirements and habitat preferences in the relevant models.

    Data Encryption: Securely encrypt employee PII fields in the database.

    GraphQL Setup: Setup GraphQL with Ruby on Rails, defining types and mutations that support nested attributes, showcasing how to create or update complex data structures in a single request.

    API: Create a GraphQL API endpoint for `createAnimal` to create a new animal, and create a new habitat, or assign it to an existing habitat.

    API: Create a GraphQL API endpoint for `createNote` to create a new note tied to an `Employee`, and the same note can also be tied to an `Animal` and/or `Habitat`.
    (update this, just or)

    API: Create a GraphQL endpoint `getAnimals` which can return all animals, and can be filtered for `in_habitat` and/or `needing_attention` which will return the applicable animals. The animal data should include dietary requirements and habitat preferences, as well as notes on the animal and its habitat and which employee created the notes.

    Seed Data: Provide seed data that illustrates the system's functionality, including various animals, habitats, employee roles, and notes/comments.

     **Test Suite**: Write a comprehensive test suite covering models, requests, and GraphQL mutations to ensure the system works as expected and handles edge cases.


---

Savvy Labs Inc


thoughts:

story:
zoo - local zoo
doesn't need auth
simple + cheap to run infra wise

intentions
scale upwards
multitenancy with other zoos

some sample user types:
vet
  ensure the health of an animal
  2-3 vets per zoo
  strawman workflow:
    caretaker notices health concerns about animal, sets/changes status of animal, triggers task creation for vet to do something

caretaker
  general care/chores around the zoo
    e.g. feed animals, groundskeeping, clean the pens/habitats, general health checkups
    tasks which may be created on a scheduled cadence (feed penguins daily at 2 and 8pm)

manager
  office manager
  scheduling
  payroll
  hiring/benefits/hr
  manages some number of employees
  need to track relationship between manager and their reports


no different functionality exposed/hidden from different user types


## models/domain objects:
----
animals
  belongs_to :habitat
  has_many :notes, as: notable

  status: string (enum)
  feeding_times: array/list (timestamp)
  "flexible data": json (e.g. dietary requirements)

habitats
  has_many :animals
  has_many :notes, as: :notable

  name: string
  environment_description: json
    e.g. temperature range, water bodies, trees, sand, etc

employees (can also be considered users)
  belongs_to :manager
  has_many :notes
  has_one :pii

  role: string (enum) (ex: vet, manager, caretaker)
  tasks: array/list
  auth_token: strawman implementation for now

pii (encrypt this)
  belongs_to :employee
  first_name
  last_name
  email
  phone

notes
  content: text
  has_many: note_tags
  belongs_to: author (employee)
  belongs_to: notable (what the note applies to, need better naming)


## rough/strawman UX
vet
  login -> sees dashboard with some priority tasks
    likely want to log in at start of day to see prior day's events/needs and what to do today
  example:
    task of health check on rhino

    able to update/add notes on their assigned domain (animal/habitat etc)

manager:
  login ->
    similar workflow to vet, login at start of day to plan their daily actions
    notify/update employees to things they need to do

caretaker:
  login ->
    probably want to log in at end of day to update/make notes on things they noticed etc.

## api design:
----
create_animal
assign_animal_to_habitat
create_note
  create on employee
attach_note_to (other object, e.g. habitat, animal etc)
get_animals
  filtering
    by habitat
    bu needing_attention (possibly other statuses)
  dietary requirements
  habitat preferences
  notes on the animal
    employee who created the note
  notes on it's habitat

TBD:
  login
  manager creating new employee?



scaling discussion
----
