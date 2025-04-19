# FCI EduTrack

A Flutter-based educational platform for universities and colleges.

## Getting Started

This project is a Flutter application for educational institution management.

## Features

### Draft Functionality for Assignments and Quizzes

The application implements frontend-only draft functionality for assignments and quizzes. This means:

- When a professor creates an assignment or quiz, they can save it as a draft locally
- Draft assignments/quizzes are stored only in the frontend state (not in the backend database)
- Drafts can be edited and published later
- Once published, assignments/quizzes are sent to the backend and become permanent

#### How it works

1. When creating a quiz or assignment, a professor can click "Save as Draft"
2. The draft is stored in the provider's state (QuizProvider or AssignmentProvider)
3. The draft persists as long as the app is running
4. The draft can be accessed from the respective drafts screen
5. When published, the draft is sent to the backend and removed from local storage

This approach allows professors to work on assignments and quizzes incrementally before making them available to students.

## For Developers

- The draft state is managed in `QuizProvider` and `AssignmentProvider` classes
- Draft screens are in `screens/professor/quiz_drafts_screen.dart` and `screens/assignment/assignment_drafts_screen.dart`
- Draft functionality is frontend-only: the backend API has no concept of drafts

## Additional Resources

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
