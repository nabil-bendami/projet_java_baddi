package ma.estsb.presencebackend.service;

import ma.estsb.presencebackend.dto.LoginRequest;
import ma.estsb.presencebackend.dto.LoginResponse;
import ma.estsb.presencebackend.model.User;
import ma.estsb.presencebackend.repository.UserRepository;
import ma.estsb.presencebackend.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public LoginResponse login(LoginRequest request) {
        // Authenticate user
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        // Get user details
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Generate JWT token
        String token = jwtUtil.generateToken(user.getEmail());

        // Create response
        LoginResponse.UserDTO userDTO = new LoginResponse.UserDTO(
                user.getId(),
                user.getFullName(),
                user.getEmail(),
                user.getRole()
        );

        return new LoginResponse(token, userDTO);
    }

    public User register(User user) {
        // Check if email already exists
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        // Hash password
        user.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));

        // Save user
        return userRepository.save(user);
    }
}
