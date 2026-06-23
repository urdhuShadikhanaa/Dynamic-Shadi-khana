trigger BookingEmailRequestTrigger on Booking_Email_Request__e (after insert) {
    for (Booking_Email_Request__e request : Trigger.new) {
        if (String.isBlank(request.Booking_Id__c)) {
            continue;
        }

        ShadikhanaBookingEmailService.sendBookingRequestEmailsNow((Id) request.Booking_Id__c);
        ShadikhanaBookingSmsService.sendBookingRequestSmsNow((Id) request.Booking_Id__c);
    }
}