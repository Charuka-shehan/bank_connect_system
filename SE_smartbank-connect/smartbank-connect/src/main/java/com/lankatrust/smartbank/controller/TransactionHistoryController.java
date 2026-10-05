package com.lankatrust.smartbank.controller;

import com.lankatrust.smartbank.entity.User;
import com.lankatrust.smartbank.service.AccountService;
import com.lankatrust.smartbank.service.TransactionService;
import com.lankatrust.smartbank.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;

@Controller
public class TransactionHistoryController {

    private final TransactionService transactionService;
    private final AccountService accountService;
    private final UserService userService;

    public TransactionHistoryController(TransactionService transactionService,
                                        AccountService accountService,
                                        UserService userService) {
        this.transactionService = transactionService;
        this.accountService = accountService;
        this.userService = userService;
    }

    @GetMapping("/history")
    public String history(@RequestParam(required = false) Long accountId,
                           @RequestParam(required = false) String startDate,
                           @RequestParam(required = false) String endDate,
                           Authentication authentication, Model model) {
        User customer = userService.getByEmail(authentication.getName());
        var accounts = accountService.getForCustomer(customer.getId());
        if (accounts.isEmpty() || customer.getRole() == com.lankatrust.smartbank.entity.Role.BANK_MANAGER || customer.getRole() == com.lankatrust.smartbank.entity.Role.SYSTEM_ADMINISTRATOR) {
            accounts = accountService.getAll();
        }
        model.addAttribute("accounts", accounts);

        Long targetAccountId = null;
        if (accountId != null) {
            boolean ownsAccount = (customer.getRole() == com.lankatrust.smartbank.entity.Role.BANK_MANAGER || customer.getRole() == com.lankatrust.smartbank.entity.Role.SYSTEM_ADMINISTRATOR)
                    || accounts.stream().anyMatch(a -> a.getId().equals(accountId));
            if (!ownsAccount) {
                throw new org.springframework.security.access.AccessDeniedException("Access denied: You do not have permission to view transactions for this account.");
            }
            targetAccountId = accountId;
        } else if (!accounts.isEmpty()) {
            targetAccountId = accounts.get(0).getId();
        }

        model.addAttribute("startDate", startDate != null ? startDate.trim() : "");
        model.addAttribute("endDate", endDate != null ? endDate.trim() : "");

        if (targetAccountId != null) {
            boolean hasStart = startDate != null && !startDate.isBlank();
            boolean hasEnd = endDate != null && !endDate.isBlank();

            if (hasStart || hasEnd) {
                try {
                    java.time.LocalDate startD = hasStart ? java.time.LocalDate.parse(startDate.trim()) : null;
                    java.time.LocalDate endD = hasEnd ? java.time.LocalDate.parse(endDate.trim()) : null;

                    if (startD != null && endD != null && startD.isAfter(endD)) {
                        model.addAttribute("error", "The \"To\" date must not be earlier than the \"From\" date.");
                        model.addAttribute("transactions", java.util.Collections.emptyList());
                    } else {
                        LocalDateTime start = (startD != null) ? startD.atStartOfDay() : java.time.LocalDate.of(1970, 1, 1).atStartOfDay();
                        LocalDateTime end = (endD != null) ? endD.atTime(23, 59, 59) : LocalDateTime.now().plusYears(100);
                        model.addAttribute("transactions", transactionService.filterHistory(targetAccountId, start, end));
                    }
                } catch (Exception ex) {
                    model.addAttribute("error", "Invalid date format. Please use YYYY-MM-DD.");
                    model.addAttribute("transactions", java.util.Collections.emptyList());
                }
            } else {
                model.addAttribute("transactions", transactionService.historyForAccount(targetAccountId));
            }
            model.addAttribute("selectedAccountId", targetAccountId);
        }
        return "history/list";
    }
}
