# 🏥 CareLink – Connected Healthcare Management System

CareLink is a multi-role healthcare management system built using Flutter and Supabase, designed to streamline communication and data management between Doctors, Patients, and Caretakers.
The system focuses on appointment management, patient health tracking, and role-based access control using secure backend policies.

---

### 🚀 Tech Stack

### Frontend
- Flutter
- Dart
- Responsive UI (Mobile, Web, Desktop)

### Backend & Database
- Supabase
  - Authentication (Email/Password)
  - PostgreSQL Database
  - Row Level Security (RLS)
  - Real-time & REST APIs

### Other Tools
- Supabase Flutter SDK
- Material UI
- Git & GitHub for version control


## 📱 Applications Included

This repository contains multiple Flutter applications:

### 1️⃣ Doctor App

Used by doctors to:

- View assigned patients

- Manage appointments

- Review patient health data

- Create prescriptions

### 2️⃣ Patient / Caretaker App

Used by patients and caretakers to:

- Log in securely

- View appointments and prescriptions

- Track health data (e.g. vitals, symptoms)

- Access and share medical data with assigned doctors

---

## ▶️ How to Run the Project

**Run Doctor App**
```bash
flutter run -t lib/Doctor_App/main_doctor.dart
```
**Run Patient & Caretaker App**
```bash
flutter run -t lib/Patient_Caretaker_app/main_patient.dart
```

💡 Make sure you have Flutter installed and Supabase credentials correctly configured.

---

## 🧩 Project Modules

### 🔐 Authentication

- Supabase Auth

- Role-based login (Doctor / Patient / Caretaker)


### 👨‍⚕️ Doctor Module

- Doctor profile management

- View assigned patients

- Appointment overview

- Prescription management

### 🧑‍🤝‍🧑 Patient & Caretaker Module

- Patient profile & medical info

- Caretaker assignment

- Health data logging

- Appointment viewing


### 📅 Appointments

- Create & manage appointments

- Status tracking (pending, confirmed, completed)

- Doctor–Patient–Caretaker linkage

### 💊 Prescriptions

- Prescription creation by doctors

- Multiple prescription items

- Linked with appointments


### 📊 Health Data

- Blood pressure

- Blood sugar

- Medication tracking

- Symptoms & remarks


## 🗄️ Database Schema (Supabase)

### Tables Used

- `auth.users` (Supabase Authentication)
- `user_profiles`
- `doctor_profiles`
- `patient_profiles`
- `caretaker_profiles`
- `appointments`
- `prescriptions`
- `prescription_items`
- `health_data`
---

### Database Design Highlights

- Role-based access control
- Doctor–Patient–Caretaker relationships
- Secure data isolation across users

---

### 🧾 Data Insertion Flow (Supabase)

To maintain referential integrity and comply with **foreign key constraints** and **Row Level Security (RLS)** policies, records must be inserted into the database in a specific order.

### Correct Insertion Order

1. **User Authentication (Supabase Auth)**
   - A user is first created using Supabase Authentication.
   - This inserts a record into:
        - `auth.users`

2. **Base User Profile**
   - After successful signup, a corresponding entry is created in:
     - `user_profiles`
   - This table stores common user information such as:
     - `full_name`
     - `email`
     - `role` (doctor / patient / caretaker)

3. **Role-Specific Profile**
   - Based on the user’s assigned role, an entry is created in one of the following tables:
     - `doctor_profiles`
     - `patient_profiles`
     - `caretaker_profiles`
   - These tables store role-specific data and maintain relationships with:
     - other users (doctor–patient–caretaker links)
     - appointments, prescriptions, and health records

### Why This Order Matters

- Foreign key constraints rely on existing records in `auth.users` and `user_profiles`
- RLS policies often reference the authenticated user (`auth.uid()`)
- Ensures consistent role-based access and prevents orphaned records
- Avoids permission errors and failed inserts during signup

> ⚠️ Skipping or reordering these steps may result in  
> **foreign key violations**, **RLS denials**, or **incomplete user setup**.

--- 

## 🔒 Security & Access Control

- Extensive use of **Row Level Security (RLS)**
- Data access is strictly controlled based on:
  - User role
  - Ownership (doctor, patient, caretaker relationships)
- Prevents unauthorized reads and writes at the database level

> Even if a user bypasses the frontend, **RLS policies ensure data safety**.

---

## 🌱 Future Enhancements

Planned improvements for future versions include:

### 🎨 Improved UX/UI
- Better responsiveness across devices
- Cleaner and more intuitive dashboards
- Enhanced accessibility

### 🛠️ Admin Application
- Separate admin application
- Centralized user and role management
- System monitoring and control

### ⚙️ Backend Improvements
- Optimized database queries
- Better indexing strategies
- Enhanced and fine-grained RLS policies
- Analytics and reporting support

---

## 📌 Notes

- This project is under active development
- The architecture is modular and designed to support scaling
- Supabase RLS is a **core design choice** for security and data protection

---

## 🤝 Contributors

Developed as part of a collaborative learning and development effort,  
focusing on **real-world healthcare workflows** and **secure system design**.
