package ma.estsb.presencebackend.controller;

import jakarta.validation.Valid;
import ma.estsb.presencebackend.model.Session;
import ma.estsb.presencebackend.service.SessionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/sessions")
@CrossOrigin(origins = "*")
public class SessionController {

    @Autowired
    private SessionService sessionService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'PROF')")
    public ResponseEntity<List<Session>> getAllSessions(@RequestParam(required = false) String group) {
        if (group != null && !group.isEmpty()) {
            List<Session> sessions = sessionService.getSessionsByGroup(group);
            return ResponseEntity.ok(sessions);
        }
        List<Session> sessions = sessionService.getAllSessions();
        return ResponseEntity.ok(sessions);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROF')")
    public ResponseEntity<Session> getSessionById(@PathVariable Long id) {
        Session session = sessionService.getSessionById(id);
        return ResponseEntity.ok(session);
    }

    @GetMapping("/professor/{professorId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROF')")
    public ResponseEntity<List<Session>> getSessionsByProfessor(@PathVariable Long professorId) {
        List<Session> sessions = sessionService.getSessionsByProfessor(professorId);
        return ResponseEntity.ok(sessions);
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'PROF')")
    public ResponseEntity<Session> createSession(@Valid @RequestBody Session session) {
        Session createdSession = sessionService.createSession(session);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdSession);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROF')")
    public ResponseEntity<Session> updateSession(@PathVariable Long id, @Valid @RequestBody Session session) {
        Session updatedSession = sessionService.updateSession(id, session);
        return ResponseEntity.ok(updatedSession);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'PROF')")
    public ResponseEntity<Void> deleteSession(@PathVariable Long id) {
        sessionService.deleteSession(id);
        return ResponseEntity.noContent().build();
    }
}
