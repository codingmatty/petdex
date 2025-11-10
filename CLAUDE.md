# PetDex - Rails Application

## Project Overview

PetDex is a Rails 8.1 application designed to help pet owners manage comprehensive pet care records. The application supports multiple pet types (dogs, cats, horses, and others) and provides a centralized platform for tracking medical history, prescriptions, care instructions, photos, and general notes.

## Tech Stack

- **Framework**: Rails 8.1.1
- **Database**: PostgreSQL
- **Asset Pipeline**: Propshaft
- **CSS**: Tailwind CSS / DaisyUI
- **JavaScript**: Hotwire (Turbo + Stimulus), Importmap
- **File Storage**: Active Storage with image_processing gem
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **WebSockets**: Solid Cable
- **Server**: Puma
- **Deployment**: Docker-ready with Kamal support

## Core Features

### 1. Pet Management
- Create, read, update, and delete pet records
- Support for multiple pet types (dog, cat, horse, bird, rabbit, etc.)
- Track essential information:
  - Name, breed, species
  - Date of birth / age
  - Adoption date
  - Weight and size, including historical values
  - Microchip number
  - Owner information
  - Special characteristics or markings

### 2. Photo Management
- Upload multiple photos per pet using Active Storage
- Display photo galleries
- Set primary/profile photo
- Ability to favorite photos
- Image variants for thumbnails and displays
- Support for common formats (JPEG, PNG, HEIC, etc.)

### 3. Notes System
- Create timestamped notes for each pet
- Categories: General, Medical, Behavioral, Diet, Training
- Rich text editor support (Action Text)
- Search and filter notes
- Pin important notes
- Attach photos to notes that can be viewed in the gallery

### 4. Prescription Management
- Track medications and prescriptions
- Record:
  - Medication name and type
  - Dosage and frequency
  - Prescribing veterinarian
  - Start and end dates
  - Refill information
  - Administration instructions
- Active/expired prescription status
- Renewal reminders

### 5. Veterinary Care Instructions
- Store care instructions from vet visits
- Link to specific appointments or conditions
- Track:
  - Visit date and veterinarian
  - Diagnosis/condition
  - Treatment plan
  - Follow-up requirements
  - Restrictions or special care
- Attach related documents or lab results

## Data Model

### Core Models

```ruby
# Pet
- name: string
- species: string (dog, cat, horse, bird, rabbit, other)
- breed: string
- date_of_birth: date
- adoption_date: date
- microchip_number: string
- sex: string (male, female, unknown)
- neutered: boolean
- color_markings: text
- owner_id: references (if multi-user)
- created_at, updated_at

# Pet Weight
- pet_id: references
- weight: decimal
- created_at, updated_at

# Note
- pet_id: references
- title: string
- category: string (general, medical, behavioral, diet, training)
- content: text (or ActionText rich_text)
- pinned: boolean
- created_at, updated_at

# Prescription
- pet_id: references
- medication_name: string
- medication_type: string (oral, topical, injection, etc.)
- dosage: string
- frequency: string
- prescribing_vet: string
- start_date: date
- end_date: date
- refills_remaining: integer
- instructions: text
- active: boolean
- created_at, updated_at

# VetInstruction (or CareInstruction)
- pet_id: references
- visit_date: date
- veterinarian_name: string
- clinic_name: string
- diagnosis: string
- treatment_plan: text
- follow_up_date: date
- special_instructions: text
- restrictions: text
- created_at, updated_at

# Photos (via Active Storage)
- Uses Active Storage attachments
- Pet has_many_attached :photos
```

### Additional Models (Future Enhancements)

```ruby
# Appointment
- pet_id: references
- appointment_date: datetime
- clinic_name: string
- veterinarian_name: string
- reason: string
- status: string
- notes: text

# VaccinationRecord
- pet_id: references
- vaccine_name: string
- date_administered: date
- next_due_date: date
- veterinarian: string
- batch_number: string

# WeightLog
- pet_id: references
- weight: decimal
- measured_at: date
- notes: text
```

## Development Guidelines

### Code Style
- Follow Rails conventions and best practices
- Use Rubocop with Rails Omakase configuration
- Run `rubocop -A` to auto-correct style issues
- Security checks with Brakeman and Bundler Audit

### Database
- Use migrations for all schema changes
- Add appropriate indexes for foreign keys and frequently queried fields
- Validate data at both model and database levels

### File Storage
- Configure Active Storage for local development (disk service)
- Plan for cloud storage in production (S3, GCS, etc.)
- Generate image variants for different display contexts:
  - Thumbnail: 150x150
  - Medium: 500x500
  - Large: 1200x1200

### UI/UX Principles
- Mobile-first responsive design with Tailwind and DaisyUI
- Use Turbo Frames for fast, partial page updates
- Stimulus controllers for interactive components
- Accessible forms with proper labels and error handling
- Clear navigation and breadcrumbs

### Testing
- Use RSpec for unit testing
- Model tests for validations and associations
- Controller tests for authorization
- Use fixtures or factories for test data - for every model created, there should be a factory for testing
- Write system tests for critical user flows

### Security Considerations
- Validate and sanitize all user inputs
- Use strong parameters in controllers
- Implement authentication (consider Devise or Rails built-in authentication)
- Add authorization for multi-user scenarios (consider Pundit)
- Sanitize file uploads (check file types, scan for malware)
- Use HTTPS in production
- Set appropriate Content Security Policy headers

## Application Structure

### Routes Organization
```ruby
resources :pets do
  resources :notes, only: [:index, :create, :update, :destroy]
  resources :prescriptions
  resources :vet_instructions
  resources :photos, only: [:create, :destroy]
end
```

### Controller Hierarchy
- ApplicationController (base authentication/authorization)
- PetsController (CRUD operations)
- NotesController (nested under pets)
- PrescriptionsController (nested under pets)
- VetInstructionsController (nested under pets)
- PhotosController (handle uploads/deletions)

### View Patterns
- Use partials for reusable components (pet card, note card, etc.)
- Turbo Frames for inline editing
- Turbo Streams for real-time updates
- Stimulus controllers for:
  - Image upload preview
  - Form validation
  - Auto-save drafts
  - Date pickers
  - Search/filter

## API Considerations (Future)

If exposing an API:
- Use versioned API namespace (`/api/v1`)
- JSON responses with Jbuilder
- Token-based authentication
- Rate limiting
- Comprehensive API documentation

## Environment Setup

### Configuration Files
- `config/database.yml` - Database configuration
- `config/storage.yml` - Active Storage configuration
- `config/tailwind.config.js` - Tailwind customization
- `.env` - Environment variables (not in version control)

## Deployment

- Docker-ready with included Dockerfile
- Kamal for deployment orchestration
- Use environment variables for secrets
- Configure production storage (S3/GCS)
- Set up background job processing
- Configure Action Cable for production
- Enable SSL/TLS

## Future Enhancements

1. **Appointment Scheduling**
   - Calendar integration
   - Reminders via email/SMS
   - Recurring appointments

2. **Vaccination Tracking**
   - Immunization records
   - Due date reminders
   - Compliance tracking

3. **Multi-User Support**
   - User accounts and authentication
   - Pet ownership/sharing
   - Veterinarian roles
   - Family member access

4. **Document Management**
   - Upload PDFs (lab results, X-rays)
   - OCR for document search
   - Secure document storage

5. **Health Metrics Dashboard**
   - Weight trends
   - Medication adherence
   - Upcoming appointments
   - Health score indicators

6. **Reporting**
   - Medical history reports
   - Export to PDF
   - Share with veterinarians

7. **Mobile App**
   - Native iOS/Android apps
   - Push notifications
   - Offline access

8. **Integrations**
   - Veterinary clinic systems
   - Pet insurance providers
   - Pharmacy services

## Getting Started with Development

When implementing new features:

1. **Plan the feature**
   - Define requirements clearly
   - Sketch out the data model
   - Consider edge cases

2. **Create migration and model**
   - Generate migration: `rails g model ModelName`
   - Add validations and associations
   - Write model tests

3. **Build the controller**
   - Generate controller: `rails g controller ModelNames`
   - Implement CRUD actions
   - Use strong parameters

4. **Create views**
   - Follow Tailwind/Hotwire patterns
   - Use partials for reusability
   - Add Turbo Frames where appropriate

5. **Add Stimulus controllers**
   - Generate: `rails g stimulus ControllerName`
   - Keep controllers focused and simple
   - Use data attributes for configuration

6. **Test thoroughly**
   - Write system tests for user flows
   - Test edge cases and error handling
   - Verify mobile responsiveness

7. **Document changes**
   - Update README if needed
   - Add inline code comments for complex logic
   - Update this CLAUDE.md for architectural changes

## Common Commands

```bash
# Generate a new model
rails g model Pet name:string species:string breed:string

# Generate a controller
rails g controller Pets index show new create edit update destroy

# Generate a migration
rails g migration AddMicrochipNumberToPets microchip_number:string

# Run migrations
rails db:migrate

# Rollback migration
rails db:rollback

# Generate Stimulus controller
rails g stimulus pet-form

# Run tests
rails test
rails test:system

# Run console
rails console

# Security audit
bundle exec bundler-audit
bundle exec brakeman

# Code style
bundle exec rubocop -A
```

## Project Conventions

- **Naming**: Use clear, descriptive names for models, methods, and variables
- **File Organization**: Keep related files together (e.g., concerns, services)
- **Commits**: Write descriptive commit messages following conventional commits format
- **Branches**: Use feature branches for new development
- **Documentation**: Update docs when changing architecture or adding major features

## Questions or Issues?

When encountering issues or needing clarification:
1. Check Rails guides: https://guides.rubyonrails.org
2. Review Hotwire documentation: https://hotwired.dev
3. Consult Tailwind docs: https://tailwindcss.com/docs
4. Ask for clarification before making architectural decisions

---

**Last Updated**: 2025-11-09
**Rails Version**: 8.1.1
**Ruby Version**: Check `.ruby-version` or `Gemfile`
