package com.lankatrust.smartbank.controller;

import com.lankatrust.smartbank.entity.User;
import com.lankatrust.smartbank.service.AccountService;
import com.lankatrust.smartbank.service.TransactionService;
import com.lankatrust.smartbank.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;

@Controller
@RequiredArgsConstructor
public class TransactionHistoryController {

    private final TransactionService transactionService;
    private final AccountService accountService;
    private final UserService userService;

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

        if (targetAccountId != null) {
            if (startDate != null && endDate != null && !startDate.isBlank() && !endDate.isBlank()) {
                try {
                    LocalDateTime start = LocalDateTime.parse(startDate.trim() + "T00:00:00");
                    LocalDateTime end = LocalDateTime.parse(endDate.trim() + "T23:59:59");
                    if (start.isAfter(end)) {
                        model.addAttribute("error", "Start date cannot be after end date.");
                        model.addAttribute("transactions", java.util.Collections.emptyList());
                    } else {
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
