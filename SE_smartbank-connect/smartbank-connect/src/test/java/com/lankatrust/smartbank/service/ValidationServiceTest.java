package com.lankatrust.smartbank.service;

import com.lankatrust.smartbank.entity.Account;
import com.lankatrust.smartbank.entity.Customer;
import com.lankatrust.smartbank.entity.User;
import com.lankatrust.smartbank.repository.AccountRepository;
import com.lankatrust.smartbank.repository.CustomerRepository;
import com.lankatrust.smartbank.repository.UserRepository;
import com.lankatrust.smartbank.service.impl.ValidationServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class ValidationServiceTest {

    @Mock private AccountRepository accountRepository;
    @Mock private UserRepository userRepository;
    @Mock private CustomerRepository customerRepository;

    private ValidationServiceImpl validationService;

    @BeforeEach
    void setUp() {
        validationService = new ValidationServiceImpl(accountRepository, userRepository, customerRepository);
    }

    @Test
    void validateEmailAcceptsValidFormats() {
        assertDoesNotThrow(() -> validationService.validateEmail("user@example.com"));
        assertDoesNotThrow(() -> validationService.validateEmail("john.doe@bank.lk"));
    }

    @Test
    void validateEmailRejectsInvalidFormats() {
        assertThrows(IllegalArgumentException.class, () -> validationService.validateEmail(""));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateEmail(null));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateEmail("invalid-email"));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateEmail("user@"));
    }

    @Test
    void validatePhoneNumberAcceptsValidFormats() {
        assertDoesNotThrow(() -> validationService.validatePhoneNumber("0771234567"));
        assertDoesNotThrow(() -> validationService.validatePhoneNumber("+94771234567"));
        assertDoesNotThrow(() -> validationService.validatePhoneNumber("077-123-4567"));
    }

    @Test
    void validatePhoneNumberRejectsInvalidFormats() {
        assertThrows(IllegalArgumentException.class, () -> validationService.validatePhoneNumber(""));
        assertThrows(IllegalArgumentException.class, () -> validationService.validatePhoneNumber("abc123"));
        assertThrows(IllegalArgumentException.class, () -> validationService.validatePhoneNumber("123"));
    }

    @Test
    void validateNicAcceptsOldAndNewFormats() {
        assertDoesNotThrow(() -> validationService.validateNic("912345678V"));
        assertDoesNotThrow(() -> validationService.validateNic("912345678v"));
        assertDoesNotThrow(() -> validationService.validateNic("199123456789"));
        assertDoesNotThrow(() -> validationService.validateNic("200012345678"));
    }

    @Test
    void validateNicRejectsInvalidFormats() {
        assertThrows(IllegalArgumentException.class, () -> validationService.validateNic("12345"));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateNic("912345678Z"));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateNic(""));
    }

    @Test
    void validateAmountRequiresPositive() {
        assertDoesNotThrow(() -> validationService.validateAmount(new BigDecimal("100.00")));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateAmount(null));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateAmount(BigDecimal.ZERO));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateAmount(new BigDecimal("-10.00")));
    }

    @Test
    void validateAgeEnforcesMinimumAge() {
        LocalDate adult = LocalDate.now().minusYears(20);
        LocalDate minor = LocalDate.now().minusYears(16);

        assertDoesNotThrow(() -> validationService.validateAge(adult, 18));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateAge(minor, 18));
    }

    @Test
    void validateDateNotFutureRejectsFutureDates() {
        LocalDate past = LocalDate.now().minusDays(5);
        LocalDate future = LocalDate.now().plusDays(2);

        assertDoesNotThrow(() -> validationService.validateDateNotFuture(past, "Date of birth"));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateDateNotFuture(future, "Date of birth"));
    }

    @Test
    void validateLoanAmountEnforcesMinAndMax() {
        assertDoesNotThrow(() -> validationService.validateLoanAmount(new BigDecimal("50000.00")));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateLoanAmount(new BigDecimal("5000.00")));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateLoanAmount(new BigDecimal("60000000.00")));
    }

    @Test
    void validateInitialDepositEnforcesThresholds() {
        assertDoesNotThrow(() -> validationService.validateInitialDeposit("SAVINGS", new BigDecimal("1000.00")));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateInitialDeposit("SAVINGS", new BigDecimal("500.00")));

        assertDoesNotThrow(() -> validationService.validateInitialDeposit("CURRENT", new BigDecimal("5000.00")));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateInitialDeposit("CURRENT", new BigDecimal("2000.00")));

        assertDoesNotThrow(() -> validationService.validateInitialDeposit("FIXED_DEPOSIT", new BigDecimal("50000.00")));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateInitialDeposit("FIXED_DEPOSIT", new BigDecimal("40000.00")));
    }

    @Test
    void validateDestinationNotSourceRejectsIdenticalAccounts() {
        assertDoesNotThrow(() -> validationService.validateDestinationNotSource(1L, 2L));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateDestinationNotSource(1L, 1L));
    }

    @Test
    void validateAccountOwnershipPreventsIdor() {
        Customer owner = Customer.builder().id(10L).email("owner@bank.lk").build();
        User attacker = User.builder().id(99L).email("attacker@bank.lk").build();
        Account account = Account.builder().id(1L).customer(owner).build();

        assertDoesNotThrow(() -> validationService.validateAccountOwnership(account, owner));
        assertThrows(IllegalArgumentException.class,
                () -> validationService.validateAccountOwnership(account, attacker));
    }

    @Test
    void validateAdminSettingsRangeChecks() {
        assertDoesNotThrow(() -> validationService.validateAdminSettings(10, 3, 3, 30, 5));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateAdminSettings(0, 3, 3, 30, 5));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateAdminSettings(10, 0, 3, 30, 5));
        assertThrows(IllegalArgumentException.class, () -> validationService.validateAdminSettings(10, 3, 3, 2, 5));
    }
}
