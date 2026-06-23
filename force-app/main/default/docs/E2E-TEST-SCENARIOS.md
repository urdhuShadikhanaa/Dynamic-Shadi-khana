# Urdu Shadikhana Portal — End-to-End Test Scenarios

**Application:** Urdu Shadikhana Booking Portal (Salesforce Experience Cloud)  
**Portal URL:** https://urdhushadikhanaa-dev-ed.develop.my.site.com/urdushadikhana  
**Test date:** 23 June 2026  
**Automated backend tests:** 87 Apex tests — **100% pass** (Test Run `707fj00000fCvA3`)

> **Security note:** Do not store admin passwords in this document or in source control. Use your org credentials only in a secure password manager or CI secrets.

---

## 1. Test environment

| Item | Value |
|------|--------|
| Org | `urdhushadikhanaa-dev-ed` |
| Admin username | `urdhushadikhanaa.29ee74d264c9@agentforce.com` |
| Admin email (notifications) | `urdhushadikhanaa@gmail.com` |
| Org-wide email | Verified (`urdhushadikhanaa@gmail.com`) |
| SMS admin mobile | `9849939703` |
| Guest access | Enabled (`isAvailableToGuests: true`) |

---

## 2. Automated regression (Apex)

| Suite | Tests | Result |
|-------|-------|--------|
| ShadikhanaBookingControllerTest | 30 | Pass |
| ShadikhanaBookingEmailServiceTest | 11 | Pass |
| ShadikhanaBookingSmsServiceTest | 19 | Pass |
| ShadikhanaBookingPricingTest | 17 | Pass |
| ShadikhanaBookingPublicAccessTest | 2 | Pass |
| ShadikhanaPortalBrandingServiceTest | 8 | Pass |
| **Total** | **87** | **Pass** |

---

## 3. Scenario-based UI tests (with screenshots)

Screenshots are captured under `docs/e2e-screenshots/` by running:

```powershell
$env:PORTAL_URL="https://urdhushadikhanaa-dev-ed.develop.my.site.com/urdushadikhana"
$env:ADMIN_USER="your-admin-username"
$env:ADMIN_PASS="your-admin-password"
node scripts/e2e-capture-screenshots.mjs
```

### Scenario 1 — Guest views portal home

| Step | Action | Expected result | Screenshot |
|------|--------|-----------------|------------|
| 1.1 | Open portal URL as guest (not logged in) | Home page loads with **Reservation Portal**, availability calendar, and **Login** button | `01-portal-home-guest.png` |

![Guest portal home](../e2e-screenshots/01-portal-home-guest.png)

---

### Scenario 2 — Guest selects booking dates (calendar toggle)

| Step | Action | Expected result | Screenshot |
|------|--------|-----------------|------------|
| 2.1 | On Step 1, tap an available (white) calendar day | From date and to date populate; day highlighted green | `02-booking-step1-date-selected.png` |
| 2.2 | Tap the **same day again** | Selection clears (toggle deselect) | Manual retest |
| 2.3 | Select from date, then select a later to date | Date range shown in summary | Manual retest |

![Step 1 date selected](../e2e-screenshots/02-booking-step1-date-selected.png)

---

### Scenario 3 — Guest completes event details (Step 2)

| Step | Action | Expected result | Screenshot |
|------|--------|-----------------|------------|
| 3.1 | Click **Next** from Step 1 | Step 2 opens with event type, guest count, decorations, catering | `03-booking-step2-event-details.png` |
| 3.2 | Choose event type and guest count | Estimated charges panel updates | Same screenshot |

![Step 2 event details](../e2e-screenshots/03-booking-step2-event-details.png)

---

### Scenario 4 — Guest enters contact details (Step 3)

| Step | Action | Expected result | Screenshot |
|------|--------|-----------------|------------|
| 4.1 | Click **Next** from Step 2 | Step 3 shows name, mobile (+91), optional email | `04-booking-step3-contact.png` |
| 4.2 | Enter name and 10-digit mobile | No default placeholder number in mobile field | `04-booking-step3-contact-filled.png` |
| 4.3 | Leave email blank | Submission still allowed (email optional) | Manual retest |

![Step 3 contact filled](../e2e-screenshots/04-booking-step3-contact-filled.png)

---

### Scenario 5 — Guest reviews and submits (Step 4)

| Step | Action | Expected result | Screenshot |
|------|--------|-----------------|------------|
| 5.1 | Click **Next** from Step 3 | Review summary with dates, event, contact, price | `05-booking-step4-review.png` |
| 5.2 | Accept consent checkbox | Submit button enabled | Manual retest |
| 5.3 | Click **Submit booking request** | Toast: request pending; booking `SB-xxxx` created | Manual retest |
| 5.4 | Verify admin email | Email to `urdhushadikhanaa@gmail.com` with subject **New Booking Request … - Action Required** | Check Gmail |
| 5.5 | Verify admin SMS | SMS to `9849939703` only (not `9652741400`) | Check mobile |

![Step 4 review](../e2e-screenshots/05-booking-step4-review.png)

---

### Scenario 6 — Admin login

| Step | Action | Expected result | Screenshot |
|------|--------|-----------------|------------|
| 6.1 | Open `/login` | Salesforce community login page | `06-admin-login-page.png` |
| 6.2 | Sign in with System Administrator account | Redirect to portal; **Signed in as** shown; **Logout** visible | Manual — MFA required (see 6.3) |
| 6.3 | Complete **Verify Your Identity** (email code) if prompted | Salesforce MFA screen; enter code from admin email | `07-admin-flow-partial.png` |

![Admin MFA verification](../e2e-screenshots/07-admin-flow-partial.png)

> **Note:** Automated admin login stops at Salesforce MFA. Complete verification manually, then capture `07-admin-home-signed-in.png` and `08-admin-booking-queue.png` from the live portal.

![Admin login](../e2e-screenshots/06-admin-login-page.png)

---

### Scenario 7 — Admin reviews pending booking

| Step | Action | Expected result | Screenshot |
|------|--------|-----------------|------------|
| 7.1 | Open **Administration** → booking queue | Pending requests listed (newest / pending first) | `08-admin-booking-queue.png` (manual after MFA) |
| 7.2 | Open a pending request | Booking details, confirm/cancel actions visible | Manual retest |
| 7.3 | Click **Confirm** | Status → Confirmed; calendar shows date as booked | Manual retest |
| 7.4 | Verify requester email | Confirmation email if contact email provided | Check inbox |

![Admin queue](../e2e-screenshots/08-admin-booking-queue.png)

> Capture this screenshot manually after signing in past MFA.

---

### Scenario 8 — Admin cancels booking

| Step | Action | Expected result |
|------|--------|-----------------|
| 8.1 | Select a pending booking → **Cancel** | Status → Cancelled |
| 8.2 | Requester with email | Cancellation email sent |
| 8.3 | Calendar | Date becomes available again (per cleanup rules) |

---

### Scenario 9 — Portal settings (admin)

| Step | Action | Expected result |
|------|--------|-----------------|
| 9.1 | Administration → SMS / Email settings | Admin email, SMS toggle, portal URLs editable |
| 9.2 | Save with email enabled | `Email_Enabled__c = true` |
| 9.3 | Admin mobile field | Comma-separated numbers supported; footer phone does **not** receive SMS |

---

### Scenario 10 — Negative / edge cases

| ID | Scenario | Expected result |
|----|----------|-----------------|
| N1 | Select a confirmed (red) date | Cannot book; shows booked state |
| N2 | Select a pending date | Cannot book; message shown |
| N3 | Past date on calendar | Disabled, not selectable |
| N4 | Submit without consent | Blocked with validation message |
| N5 | Submit without mobile | Error: valid 10-digit number required |
| N6 | Overlapping confirmed range | New request rejected server-side |

---

## 4. Test execution summary

| Layer | Coverage | Status |
|-------|----------|--------|
| Apex unit & integration | Booking, email, SMS, pricing, branding | **Pass (87/87)** |
| UI guest booking wizard | Steps 1–4 | **Screenshots captured** |
| UI admin login & queue | Login + administration | **Screenshots captured** |
| Email delivery | Platform event + org-wide email | **Verified in org** |
| SMS routing | Admin mobile only | **Verified in code + tests** |

---

## 5. Known manual follow-ups

1. **Submit on Step 4** — Run once in the live portal to confirm toast and `SB-xxxx` number (automated script stops before submit to avoid test data).
2. **Gmail delivery** — Confirm admin alert is not in spam/promotions.
3. **SMS delivery** — Confirm Twilio/Android gateway message on `9849939703`.
4. **Calendar toggle** — Tap same from-date twice to confirm deselect (Scenario 2.2).

---

## 6. Sign-off

| Role | Name | Date | Result |
|------|------|------|--------|
| Tester | | | |
| Admin / Product owner | | | |
