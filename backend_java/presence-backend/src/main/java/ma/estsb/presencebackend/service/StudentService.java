package ma.estsb.presencebackend.service;

import ma.estsb.presencebackend.model.Student;
import ma.estsb.presencebackend.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudentService {

    @Autowired
    private StudentRepository studentRepository;

    public List<Student> getAllStudents() {
        return studentRepository.findAll();
    }

    public Student getStudentById(Long id) {
        return studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Student not found with id: " + id));
    }

    public List<Student> getStudentsByGroup(String groupName) {
        return studentRepository.findByGroupName(groupName);
    }

    public Student createStudent(Student student) {
        if (studentRepository.existsByCne(student.getCne())) {
            throw new RuntimeException("Student with CNE " + student.getCne() + " already exists");
        }
        return studentRepository.save(student);
    }

    public Student updateStudent(Long id, Student studentDetails) {
        Student student = getStudentById(id);
        
        student.setFullName(studentDetails.getFullName());
        student.setGroupName(studentDetails.getGroupName());
        
        // Only update CNE if it's different and not already taken
        if (!student.getCne().equals(studentDetails.getCne())) {
            if (studentRepository.existsByCne(studentDetails.getCne())) {
                throw new RuntimeException("Student with CNE " + studentDetails.getCne() + " already exists");
            }
            student.setCne(studentDetails.getCne());
        }
        
        return studentRepository.save(student);
    }

    public void deleteStudent(Long id) {
        Student student = getStudentById(id);
        studentRepository.delete(student);
    }
}
