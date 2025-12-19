package ma.estsb.presencebackend.service;

import ma.estsb.presencebackend.dto.AttendanceMarkRequest;
import ma.estsb.presencebackend.model.Attendance;
import ma.estsb.presencebackend.repository.AttendanceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class AttendanceService {

    @Autowired
    private AttendanceRepository attendanceRepository;

    public List<Attendance> getAttendanceBySession(Long sessionId) {
        return attendanceRepository.findBySessionId(sessionId);
    }

    public List<Attendance> getAttendanceByStudent(Long studentId) {
        return attendanceRepository.findByStudentId(studentId);
    }

    @Transactional
    public List<Attendance> markAttendance(AttendanceMarkRequest request) {
        List<Attendance> attendanceList = new ArrayList<>();
        
        for (AttendanceMarkRequest.AttendanceRecord record : request.getRecords()) {
            // Check if attendance already exists
            if (attendanceRepository.existsBySessionIdAndStudentId(
                    request.getSessionId(), record.getStudentId())) {
                throw new RuntimeException("Attendance already marked for student ID: " + record.getStudentId());
            }
            
            Attendance attendance = new Attendance();
            attendance.setSessionId(request.getSessionId());
            attendance.setStudentId(record.getStudentId());
            attendance.setStatus(record.getStatus());
            attendance.setMarkedAt(LocalDateTime.now());
            
            attendanceList.add(attendanceRepository.save(attendance));
        }
        
        return attendanceList;
    }

    public Attendance updateAttendance(Long id, Attendance attendanceDetails) {
        Attendance attendance = attendanceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Attendance not found with id: " + id));
        
        attendance.setStatus(attendanceDetails.getStatus());
        attendance.setMarkedAt(LocalDateTime.now());
        
        return attendanceRepository.save(attendance);
    }

    public void deleteAttendance(Long id) {
        Attendance attendance = attendanceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Attendance not found with id: " + id));
        attendanceRepository.delete(attendance);
    }
}
