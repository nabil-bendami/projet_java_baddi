package ma.estsb.presencebackend.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import ma.estsb.presencebackend.model.enums.AttendanceStatus;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AttendanceMarkRequest {
    
    @NotNull(message = "Session ID is required")
    private Long sessionId;
    
    @NotEmpty(message = "Records list cannot be empty")
    private List<AttendanceRecord> records;
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AttendanceRecord {
        @NotNull(message = "Student ID is required")
        private Long studentId;
        
        @NotNull(message = "Status is required")
        private AttendanceStatus status;
    }
}
