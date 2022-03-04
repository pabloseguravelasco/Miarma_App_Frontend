package com.salesianos.dam.model.dto.Usuario;

import com.salesianos.dam.validacion.simple.anotaciones.UniqueUserEmail;
import com.salesianos.dam.validacion.simple.anotaciones.UniqueUserNick;
import lombok.*;
import org.springframework.validation.annotation.Validated;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Validated
public class CreateUserFrontendDto {

    private String nombre;

    @UniqueUserNick
    private String nick;

    @UniqueUserEmail
    private String email;

    private String password;

    private String password2;
    
    private LocalDate fechaNacimiento;


}
