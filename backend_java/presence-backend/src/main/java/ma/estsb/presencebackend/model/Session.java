package ma.estsb.presencebackend.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "sessions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Session {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Module name is required")
    @Column(nullable = false)
    private String moduleName;

    @NotBlank(message = "Group name is required")
    @Column(nullable = false)
    private String groupName;

    @NotNull(message = "Session date time is required")
    @Column(nullable = false)
    private LocalDateTime sessionDateTime;

    @NotNull(message = "Professor ID is required")
    @Column(nullable = false)
    private Long professorId;

    @Column(updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
