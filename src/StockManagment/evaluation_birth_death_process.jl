function evaluation_birth_death_process(x, param)
    (S, E, I_S, I_A, R, V, D) = x
    N = param[1]
    omega_v = param[2]
    psi_v = param[3]
    p = param[4]
    alpha_a = param[5]
    alpha_s = param[6]
    theta = param[7]
    delta_e = param[8]
    delta_r = param[9]
    epsilon = param[10]
    beta_s = param[11]
    beta_a = param[12]
    hat_N = N - D
    lambda_f = (beta_a * I_A + beta_s * I_S) * ( hat_N ^ (-1))
    vaccination = (psi_v) * S
    acquiring_virus = lambda_f * S
    developing_symptoms = p * delta_e * E
    developing_transitory_disease = (1 - p) * delta_e* E
    infection_with_symptoms_recovering = (1 - theta) * alpha_s * I_S
    death_by_disease = theta* alpha_s * I_S
    transitory_infection_recovering = alpha_a * I_A
    losing_natural_immunity = delta_r * R
    losing_vaccine_induced_immunity = omega_v * V
    virus_inoculation_by_imperfect_immunization = (1 - epsilon) * lambda_f * V
    transition = [
        vaccination,
        acquiring_virus,
        developing_symptoms,
        developing_transitory_disease,
        infection_with_symptoms_recovering,
        death_by_disease,
        transitory_infection_recovering,
        losing_natural_immunity,
        losing_vaccine_induced_immunity,
        virus_inoculation_by_imperfect_immunization
    ]
    return transition
end
