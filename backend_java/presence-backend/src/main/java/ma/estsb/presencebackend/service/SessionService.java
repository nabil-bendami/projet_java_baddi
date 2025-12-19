package ma.estsb.presencebackend.service;

import ma.estsb.presencebackend.model.Session;
import ma.estsb.presencebackend.repository.SessionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SessionService {

    @Autowired
    private SessionRepository sessionRepository;

    public List<Session> getAllSessions() {
        return sessionRepository.findAll();
    }

    public Session getSessionById(Long id) {
        return sessionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Session not found with id: " + id));
    }

    public List<Session> getSessionsByGroup(String groupName) {
        return sessionRepository.findByGroupName(groupName);
    }

    public List<Session> getSessionsByProfessor(Long professorId) {
        return sessionRepository.findByProfessorId(professorId);
    }

    public Session createSession(Session session) {
        return sessionRepository.save(session);
    }

    public Session updateSession(Long id, Session sessionDetails) {
        Session session = getSessionById(id);
        
        session.setModuleName(sessionDetails.getModuleName());
        session.setGroupName(sessionDetails.getGroupName());
        session.setSessionDateTime(sessionDetails.getSessionDateTime());
        session.setProfessorId(sessionDetails.getProfessorId());
        
        return sessionRepository.save(session);
    }

    public void deleteSession(Long id) {
        Session session = getSessionById(id);
        sessionRepository.delete(session);
    }
}
