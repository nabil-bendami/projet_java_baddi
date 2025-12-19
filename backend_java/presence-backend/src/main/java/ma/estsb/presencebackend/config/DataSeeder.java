package ma.estsb.presencebackend.config;

import ma.estsb.presencebackend.model.Attendance;
import ma.estsb.presencebackend.model.Session;
import ma.estsb.presencebackend.model.Student;
import ma.estsb.presencebackend.model.User;
import ma.estsb.presencebackend.model.enums.AttendanceStatus;
import ma.estsb.presencebackend.model.enums.UserRole;
import ma.estsb.presencebackend.repository.AttendanceRepository;
import ma.estsb.presencebackend.repository.SessionRepository;
import ma.estsb.presencebackend.repository.StudentRepository;
import ma.estsb.presencebackend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class DataSeeder implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private SessionRepository sessionRepository;

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Clear existing data (optional for development)
        // attendanceRepository.deleteAll();
        // sessionRepository.deleteAll();
        // studentRepository.deleteAll();
        // userRepository.deleteAll();

        // Seed Users
        User admin = new User();
        admin.setFullName("Admin User");
        admin.setEmail("admin@estsb.ma");
        admin.setPasswordHash(passwordEncoder.encode("password"));
        admin.setRole(UserRole.ADMIN);
        userRepository.save(admin);

        User prof = new User();
        prof.setFullName("Professor User");
        prof.setEmail("prof@estsb.ma");
        prof.setPasswordHash(passwordEncoder.encode("password"));
        prof.setRole(UserRole.PROF);
        userRepository.save(prof);

        User student = new User();
        student.setFullName("Student User");
        student.setEmail("student@estsb.ma");
        student.setPasswordHash(passwordEncoder.encode("password"));
        student.setRole(UserRole.STUDENT);
        userRepository.save(student);

        // Seed Students
        String[] firstNames = {"Ahmed", "Fatima", "Mohammed", "Aisha", "Youssef", "Khadija", "Omar", "Salma", "Hassan", "Nadia"};
        String[] lastNames = {"Alami", "Benali", "Chakir", "Drissi", "El Amrani", "Fassi", "Ghazi", "Hamdi", "Idrissi", "Jaber"};
        String[] groups = {"Groupe A", "Groupe B", "Groupe C"};

        for (int i = 0; i < 10; i++) {
            Student s = new Student();
            s.setFullName(firstNames[i] + " " + lastNames[i]);
            s.setCne("R" + String.format("%09d", 100000000 + i));
            s.setGroupName(groups[i % 3]);
            studentRepository.save(s);
        }

        // Seed Sessions
        Session session1 = new Session();
        session1.setModuleName("Programmation Java");
        session1.setGroupName("Groupe A");
        session1.setSessionDateTime(LocalDateTime.now().minusDays(2));
        session1.setProfessorId(prof.getId());
        sessionRepository.save(session1);

        Session session2 = new Session();
        session2.setModuleName("Base de Données");
        session2.setGroupName("Groupe B");
        session2.setSessionDateTime(LocalDateTime.now().minusDays(1));
        session2.setProfessorId(prof.getId());
        sessionRepository.save(session2);

        Session session3 = new Session();
        session3.setModuleName("Développement Web");
        session3.setGroupName("Groupe C");
        session3.setSessionDateTime(LocalDateTime.now());
        session3.setProfessorId(prof.getId());
        sessionRepository.save(session3);

        // Seed Attendance Records
        java.util.List<Student> groupAStudents = studentRepository.findByGroupName("Groupe A");
        for (int i = 0; i < Math.min(3, groupAStudents.size()); i++) {
            Attendance attendance = new Attendance();
            attendance.setSessionId(session1.getId());
            attendance.setStudentId(groupAStudents.get(i).getId());
            attendance.setStatus(i == 0 ? AttendanceStatus.PRESENT : (i == 1 ? AttendanceStatus.LATE : AttendanceStatus.ABSENT));
            attendance.setMarkedAt(LocalDateTime.now().minusDays(2));
            attendanceRepository.save(attendance);
        }

        java.util.List<Student> groupBStudents = studentRepository.findByGroupName("Groupe B");
        for (int i = 0; i < Math.min(3, groupBStudents.size()); i++) {
            Attendance attendance = new Attendance();
            attendance.setSessionId(session2.getId());
            attendance.setStudentId(groupBStudents.get(i).getId());
            attendance.setStatus(AttendanceStatus.PRESENT);
            attendance.setMarkedAt(LocalDateTime.now().minusDays(1));
            attendanceRepository.save(attendance);
        }

        System.out.println("✅ Data seeding completed successfully!");
        System.out.println("📧 Admin: admin@estsb.ma / password");
        System.out.println("📧 Prof: prof@estsb.ma / password");
        System.out.println("📧 Student: student@estsb.ma / password");
    }
}
