package ma.estsb.presencebackend.repository;

import ma.estsb.presencebackend.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    Optional<Student> findByCne(String cne);
    List<Student> findByGroupName(String groupName);
    boolean existsByCne(String cne);
}
