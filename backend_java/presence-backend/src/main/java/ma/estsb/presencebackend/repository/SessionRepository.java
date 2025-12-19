package ma.estsb.presencebackend.repository;

import ma.estsb.presencebackend.model.Session;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SessionRepository extends JpaRepository<Session, Long> {
    List<Session> findByGroupName(String groupName);
    List<Session> findByProfessorId(Long professorId);
    List<Session> findByGroupNameAndProfessorId(String groupName, Long professorId);
}
