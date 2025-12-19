package ma.estsb.presencebackend.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import ma.estsb.presencebackend.model.enums.AttendanceStatus;

import java.time.LocalDateTime;

@Entity
@Table(name = "attendance")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Attendance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull(message = "Session ID is required")
    @Column(nullable = false)
    private Long sessionId;

    @NotNull(message = "Student ID is required")
    @Column(nullable = false)
    private Long studentId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AttendanceStatus status;

    @Column(nullable = false)
    private LocalDateTime markedAt;

    @PrePersist
    protected void onCreate() {
        if (markedAt == null) {
            markedAt = LocalDateTime.now();
        }
    }
}
