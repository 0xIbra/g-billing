local Translations = {
    info = {
        ["bill_received_for"] = "Bill sent for $%{value} to %{to}",
        ["bill_received_from"] = "Bill received for $%{value} from %{from} \"%{senderAcc}\"",
        ["bill_due_to_canceled"] = "Bill #%{bill_number}: $%{amount} due to %{bill_sender} \"%{sender_acc}\" has been canceled",
        ["bill_canceled"] = "Bill canceled",
        ["are_you_sure_want_send_bill"] = "Are you sure you want to send this bill?",
        ["no_changed_mind"] = "No, I changed my mind!",
        ["do_you_want_to_send_bill"] = "Do you want to send a bill?",
        ["account_name"] = "Account: \"%{job_name}\"",
        ["send_a_bill"] = "• Send a Bill",
        ["cancel"] = "✖ Cancel",
        ["new_bill"] = "New Bill",
        ["confirm"] = "Confirm",
        ["recipient_server_id"] = "Recipient Server ID (#)",
        ["amount"] = "Amount ($)",
        ["view_bills"] = "• View Your Bills",
        ["view_sent_bills"] = "• View Sent Bills",
        ["send_new_bill"] = "• Send New Bill",
        ["sent_bills"] = "Sent Bills",
        ["view_pending"] = "• View Pending",
        ["view_paid"] = "• View Paid",
        ["return"] = "← Return",
        ["your_bills"] = "Your Bills",
        ["view_current_due"] = "• View Current Due",
        ["view_past_paid"] = "• View Past Paid",
        ["are_you_sure_pay_bill_for"] = "Are you sure you want to pay this bill for $%{amount}?",
        ["pay_bill_details"] = "Bill #%{bill_number}<br>Date: %{date}<br>Due to: %{sender_name} \"%{sender_acc}\"",
        ["take_me_back"] = "No, take me back!",
        ["are_you_sure_cancel_bill_for"] = "Are you sure you want to cancel this bill for $%{amount}?",
        ["cancel_bill_details_citizen"] = "Date: %{date}<br>Due to: %{sender_acc}<br>Recipient: %{recipient_name} (%{citizenid})",
        ["owed_bills"] = "Owed Bills",
        ["total_due"] = "Total Due: $%{amount}",
        ["paid_bills"] = "Paid Bills",
        ["total_paid"] = "Total Paid: $%{amount}"
    },

    error = {
        ["sending_bill"] = "Error sending bill",
        ["not_permitted"] = "You are not permitted to bill for this account!",
        ["retrieving_bills"] = "Error retrieving bills",
        ["not_enough_money_in_bank"] = "Not enough money in your bank account!",
        ["must_be_on_duty_and_authorized"] = "You must be on duty and authorized to bill for your occupation!",
        ["bill_already_paid"] = "This bill is already paid!",
        ["error_getting_recipient_id"] = "Error getting recipient ID",
        ["error_getting_bill_amount"] = "Error getting bill amount",
        ["error_getting_player_given_id"] = "Error getting player from given ID",
    },

    success = {
        ["bill_paid_by"] = "Bill #%{bill_number}: $%{amount} paid by %{client}",
        ["bill_paid_to"] = "Bill #%{bill_number}: $%{amount} paid to %{bill_sender} \"%{sender_acc}\"",
        ["amount_billed_to"] = "Amount: $%{amount} billed to %{firstname} %{lastname}",
        ["yes_send_bill_on_behalf_of"] = "Yes, send this bill on behalf of the \"%{job_name}\" account.",
        ["yes_pay_it"] = "Yes, I want to pay it!",
        ["yes_cancel_bill"] = "Yes, cancel this bill!"
    },

    historic = {
        ["bill"] = "#%{id} - $%{amount}",
        ["details"] = "Date: %{date}<br>Due to: \"%{sender_acc}\"<br>Recipient: %{recipient_name} (%{citizenid})<br>Paid: %{status_date}",
        ["details_less"] = "Date: %{date}<br>Due to: %{sender_name} \"%{sender_acc}\"",
        ["paid_bill_details"] = "Date: %{date}<br>Due to: %{sender_name} \"%{sender_acc}\"<br>Paid: %{status_date}"

    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
