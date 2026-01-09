# Clinexa – Project Plan (V1)

## 1. Overview
Clinexa is a SaaS-based medical clinic management system designed to streamline the workflow for doctors, clinics, and patients.  
The platform consists of:
- **Backend:** Node.js + Express + MongoDB
- **Mobile App (Patient):** Flutter
- **Web Dashboard (Doctor/Admin):** Flutter Web
- **Super Admin Panel:** Managed by the platform owner

The goal of Clinexa is to provide a clean, reliable, and scalable clinic management system that can be sold to multiple doctors as a subscription service.

---

## 2. User Roles

### 1) Admin
- Manage doctors
- Activate/deactivate accounts
- View global statistics
- View all patients
- View all appointments

### 2) Doctor
- Log in to the web dashboard
- View today's appointments
- Manage appointments (confirm/cancel)
- Add prescriptions
- View patient profiles
- Manage clinic information

### 3) Patient
- Register & log in to the mobile app
- Browse doctors
- Book appointments
- View upcoming/past appointments
- View prescriptions

---

## 3. Versioning & Roadmap

### ⭐ **Version 1 (V1) – MVP / Core Release**
The essential, sellable version of Clinexa.

#### V1 Goal:
A fully functional appointment & prescription system with admin and doctor control.

#### Features Included in V1:

##### 1) Authentication & Users
- Register / Login
- JWT authentication
- Role-based access (admin, doctor, patient)
- Account activation/deactivation (admin)

##### 2) Doctors Module
- Doctor profile
- Specialty
- Single clinic (V1 simplified)
- Edit profile
- View appointments

##### 3) Patients Module
- Patient profile
- View appointments
- View prescriptions

##### 4) Appointments Module
- Patient creates appointment
- Doctor confirms/cancels appointment
- Appointment status:
    - pending
    - confirmed
    - cancelled
    - completed
- Admin can view all appointments

##### 5) Prescriptions Module
- Doctor creates prescription
- Prescription items (medicines)
- Patient views prescription

##### 6) Admin Panel
- List doctors
- Add / activate / deactivate doctors
- List patients
- Basic statistics

#### Supporting Documents Completed:
- ERD (Database Design)
- API Specification
- User Journeys
- Flowcharts
- Postman Collection
- Repository structure
- Project vision

---

### ⭐ **Version 2 (V2) – PRO Clinic System**
Enhancements after V1 deployment.

#### Features:
- Notification system (SMS / Email / WhatsApp)
- Online payments
- Fee management
- Revenue tracking per doctor
- Staff roles (reception, nurse)
- Calendar view for staff
- Attachment system (medical files, photos, PDFs)

---

### ⭐ **Version 3 (V3) – Enterprise-Level Platform**
For multi-clinic, multi-branch setups.

#### Features:
- Multi-clinic / multi-branch support
- Branch-level permissions
- Advanced analytics dashboard
- Telemedicine (video calls & chat)
- Inventory & pharmacy management
- Full financial reporting

---

## 4. Modules Included in V1 (Scope Definition)

### ✔ Authentication Module
- Register & login
- JWT middleware
- Role-based authorization

### ✔ Doctors Module
- CRUD operations for doctor profile
- Clinic profile (single clinic)
- View appointments list

### ✔ Patients Module
- Update/view patient profile
- View appointments
- View prescriptions

### ✔ Clinics Module (V1 Simplified)
- Single clinic per doctor
- Patient can view clinic info

### ✔ Appointments Module
- Create appointment
- Confirm/cancel by doctor
- Cancel by patient
- Filter appointments (today/upcoming/past)

### ✔ Prescriptions Module
- Create prescription
- Add medicines/items
- Link prescriptions to appointments
- Patient views prescriptions

### ✔ Basic Dashboard Stats
- Doctor: today’s statistics
- Admin: total counts (doctors, patients, appointments)

---

## 5. Out of Scope (Not included in V1)
These are reserved for V2/V3:

- Online payments
- Notifications (SMS/WhatsApp)
- Multi-branch support
- Staff accounts
- Telemedicine
- Advanced analytics
- Inventory management

---

## 6. System Architecture

### Backend:
- Node.js
- Express.js
- MongoDB + Mongoose
- JWT Auth
- MVC folder structure

### Mobile App (Patient):
- Flutter
- Clean simple UI (V1)
- API integration

### Web Dashboard (Doctor/Admin):
- Flutter Web
- Multi-role logic
- Appointments + prescriptions management

---

## 7. Database Model (ERD Summary)

### Collections:
- `users`
- `doctors`
- `patients`
- `clinics`
- `appointments`
- `prescriptions`
- `prescription_items`

### Relationships:
- User ↔ Doctor (1:1)
- User ↔ Patient (1:1)
- Doctor ↔ Clinic (1:1)
- Doctor ↔ Appointments (1:N)
- Patient ↔ Appointments (1:N)
- Appointment ↔ Prescription (1:1)
- Prescription ↔ Prescription Items (1:N)

---

## 8. API Structure (Summary)
### Primary Routes:
- `/auth/*`
- `/users/*`
- `/doctors/*`
- `/patients/*`
- `/clinics/*`
- `/appointments/*`
- `/prescriptions/*`
- `/admin/*`
- `/doctor/*`

(Full specification available in `api-spec.md`)

---

## 9. Development Plan (Sprints)

### **Sprint 1 – Backend Setup + Auth**
- Project structure
- MongoDB connection
- User model
- Auth routes (register/login)
- JWT + role middleware

### **Sprint 2 – Doctors Module**
- Doctor model
- Doctor profile CRUD
- Clinic model

### **Sprint 3 – Patients Module**
- Patient model
- Profile update
- Patient data fetching

### **Sprint 4 – Appointments Module**
- Create appointment
- Confirm/cancel
- Filters (today/upcoming)

### **Sprint 5 – Prescriptions Module**
- Prescription model
- Items model
- Create prescription
- Prescription fetching

### **Sprint 6 – Flutter Mobile (Patient App)**
- Auth screens
- Home
- Doctor listing
- Booking flow
- My appointments
- My prescriptions

### **Sprint 7 – Flutter Web Dashboard**
- Admin/Doctor login
- Statistics
- Appointments list
- Write prescription
- Patient details

---

## 10. Definition of Done (V1)
V1 is complete when:

- All core APIs are functional
- Patient can book appointment
- Doctor can confirm/cancel appointment
- Doctor can create prescription
- Patient can view prescription
- Admin can manage doctors/patients
- Basic stats available
- Flutter mobile app works
- Flutter web dashboard works

---

## 11. Constraints
- No payments in V1
- No notifications in V1
- No multi-branch logic in V1

---

## 12. Risks & Possible Improvements
- Potential scaling issues on appointment-heavy days
- SMS/WhatsApp costs in V2
- Storage handling for medical files in V2

---

## 13. Project Status
- Planning: ✔ Completed
- ERD: ✔ Completed
- API Spec: ✔ Completed
- User Journeys: ✔ Completed
- Flowcharts: ✔ Completed
- Postman Collection: ✔ Completed
- Ready to begin: **Sprint 1 – Backend**  
