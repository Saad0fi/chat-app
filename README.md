# Chat App — Real-time BLoC + Supabase

Flutter chat application with **private messaging**, **group chat**, and **Arabic RTL UI** — built with BLoC and Supabase Realtime.

> Tuwaiq Academy bootcamp lab — portfolio showcase  
> Original Classroom repo stays private; this is a clean public copy.

## Demo

https://github.com/user-attachments/assets/ca595aa6-f04b-4fde-b8da-6ce906047789

## Features

- Email/password auth (sign up, sign in, sign out)
- Private one-on-one chat with real-time sync
- Group chat — create groups and invite users
- Arabic RTL interface with tab navigation (All / Private / Group)
- User search, avatars, hero animations, online presence

## Architecture

```
lib/
├── core/
│   └── setup.dart              # Supabase init via .env
├── feature/
│   ├── auth/
│   │   ├── bloc/               # AuthBloc
│   │   └── screens/
│   └── chat/
│       ├── bloc/               # ChatBloc + realtime streams
│       └── screens/
└── models/                     # users, messages, groups
```

### Flow

```
UI → AuthBloc / ChatBloc → Supabase (Auth + Postgres + Realtime streams)
```

## Tech Stack

| Area | Tools |
|---|---|
| State | flutter_bloc |
| Backend | supabase_flutter |
| Mapping | dart_mappable |
| UI | flutter_chat_core, flutter_chat_ui |
| Localization | flutter_localizations (ar_SA) |

## Getting Started

```bash
git clone https://github.com/Saad0fi/chat-app.git
cd chat-app
cp .env.example .env
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Required `.env` keys

```
SUPABASE_URL=https://YOUR_PROJECT.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

Copy `.env.example` → `.env`. Never commit real keys.

## How to try

1. Sign up with email/password
2. Search for another user and start a private chat
3. Create a group and add members
4. Send messages — updates appear in real time via Supabase streams

## License

Portfolio / educational use.

## Authors

Team project (Tuwaiq Flutter Bootcamp):

| GitHub | Name |
|---|---|
| [Saad0fi](https://github.com/Saad0fi) | Saad Alharbi |
| [talai-jpg](https://github.com/talai-jpg) | Talal Alharthi |
| [oom22](https://github.com/oom22) | Omar Alharbi |

