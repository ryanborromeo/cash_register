# Tech Stacks Used

* **Backend**: Ruby on Rails 8, SQLite
* **Frontend**: React, TypeScript, Inertia.js, Vite, Tailwind CSS
* **Testing**: Minitest, Capybara
* **Deployment**: Kamal, Docker

# How to run

### Prerequisites

- Ruby 3.3.0+
- Node.js 20.0.0+
- Yarn or npm

### Setup

1. **Install dependencies:**
   ```bash
   bundle install
   npm install
   ```

2. **Set up the database:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

3. **Start the server:**
   ```bash
   bin/dev
   ```

The application will be available at `http://localhost:3000`.
