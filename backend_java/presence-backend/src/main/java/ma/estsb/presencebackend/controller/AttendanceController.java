package ma.estsb.presencebackend.controller;

import jakarta.validation.Valid;
import ma.estsb.presencebackend.dto.AttendanceMarkRequest;
import ma.estsb.presencebackend.model.Attendance;
import ma.estsb.presencebackend.service.AttendanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/attendance")
@CrossOrigin(origins = "*")
public class AttendanceController {

    @Autowired
    private AttendanceService attendanceService;

    @PostMapping("/mark")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROF')")
    public ResponseEntity<List<Attendance>> markAttendance(@Valid @RequestBody AttendanceMarkRequest request) {
        List<Attendance> attendanceList = attendanceService.markAttendance(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(attendanceList);
    }

    @GetMapping("/session/{sessionId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROF')")
    public ResponseEntity<List<Attendance>> getAttendanceBySession(@PathVariable Long sessionId) {
        List<Attendance> attendanceList = attendanceService.getAttendanceBySession(sessionId);
        return ResponseEntity.ok(attendanceList);
    }

    @GetMapping("/student/{studentId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROF', 'STUDENT')")
    public ResponseEntity<List<Attendance>> getAttendanceByStudent(@PathVariable Long studentId) {
        List<Attendance> attendanceList = attendanceService.getAttendanceByStudent(studentId);
        return ResponseEntity.ok(attendanceList);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROF')")
    public ResponseEntity<Attendance> updateAttendance(@PathVariable Long id, @Valid @RequestBody Attendance attendance) {
        Attendance updatedAttendance = attendanceService.updateAttendance(id, attendance);
        return ResponseEntity.ok(updatedAttendance);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROF')")
    public ResponseEntity<Void> deleteAttendance(@PathVariable Long id) {
        attendanceService.deleteAttendance(id);
        return ResponseEntity.noContent().build();
    }
}
