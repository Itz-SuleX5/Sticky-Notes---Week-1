# Sticky Notes Application

A multi-platform sticky notes application built with Django (backend), Flutter (mobile), and React (web). Users can create, edit, move, and manage sticky notes across different platforms with real-time synchronization.

## Features

- Create, edit, and delete sticky notes
- Mark notes as completed (changes color from yellow to green)
- Random positioning of new notes
- Drag and drop functionality to reposition notes
- Cross-platform synchronization
- Offline support for mobile app
- Responsive design for both web and mobile

## Project Structure

```
├── backend/             # Django REST API
├── frontendMobile/      # Flutter mobile application
└── frontendWeb/         # React web application
```

## Backend Setup

1. Navigate to the backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run migrations:
```bash
python manage.py migrate
```

4. Create a superuser (optional):
```bash
python manage.py createsuperuser
```

5. Start the development server:
```bash
python manage.py runserver
```

The API will be available at `http://localhost:8000/api/`

## Mobile App Setup (Flutter)

1. Navigate to the mobile frontend directory:
```bash
cd frontendMobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Web App Setup (React)

1. Navigate to the web frontend directory:
```bash
cd frontendWeb
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm start
```

The web application will be available at `http://localhost:3000`

## API Endpoints

- `GET /api/notes/` - List all notes
- `POST /api/notes/` - Create a new note
- `GET /api/notes/{id}/` - Retrieve a specific note
- `PATCH /api/notes/{id}/` - Update a specific note
- `DELETE /api/notes/{id}/` - Delete a specific note

## Technologies Used

- **Backend:**
  - Django
  - Django REST Framework
  - SQLite (development)
  - CORS Headers

- **Mobile Frontend:**
  - Flutter
  - Provider (State Management)
  - Shared Preferences (Local Storage)
  - HTTP Package

- **Web Frontend:**
  - React
  - TypeScript
  - Material-UI
  - Axios

## Deployment

The application is deployed at:
- Backend: https://sticky-notes-week-1.onrender.com
- Web: [Your web deployment URL]
- Mobile: Available through respective app stores (pending)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details 