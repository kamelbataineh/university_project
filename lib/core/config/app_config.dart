//  localhost
const baseUrl   = "http://10.0.2.2:8000/";

//  (Doctor)
const doctorRegister  = baseUrl + "doctors/register";
const doctorLogin     = baseUrl + "doctors/login";
const doctorLogout    = baseUrl + "doctors/logout";
const doctorUpdate    = baseUrl + "doctors/update";
const doctorMe        = baseUrl + "doctors/me";

//  (User)
const patientRegister    = baseUrl + "patients/register";
const patientLogin       = baseUrl + "patients/login";
const patientLoginLogout = baseUrl + "patients/logout";


const String AppointmentsDoctors = baseUrl + "appointments/doctors";        // جلب قائمة الدكاترة
const String AppointmentsBook    = baseUrl + "appointments/book";          // حجز موعد
const String AppointmentsMy      = baseUrl + "appointments/my-appointments";  // جلب مواعيد المريض
const String AppointmentsDoctor  = baseUrl + "appointments/doctor-appointments";
const String AppointmentsCancel = baseUrl + "appointments/cancel/";

const String AppointmentsCancelRequest = baseUrl + "appointments/request-cancel/";

// ---------------------------------
// موافقة الدكتور على طلب إلغاء موعد
// ---------------------------------
const String AppointmentsApproveCancel = baseUrl + "appointments/approve-cancel/";