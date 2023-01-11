local Translations = {
    info = {
        ["bill_received_for"] = "Facture de %{value}€ envoyée à %{to}",
        ["bill_received_from"] = "Facture pour %{value}€ reçu de %{from} \"%{senderAcc}\"",
        ["bill_due_to_canceled"] = "Facture #%{bill_number}: %{amount}€ due à %{bill_sender} \"%{sender_acc}\" a été annulée",
        ["bill_canceled"] = "Facture annulée",
        ["are_you_sure_want_send_bill"] = "Envoyer la facture ?",
        ["no_changed_mind"] = "Non",
        ["do_you_want_to_send_bill"] = "Créer une nouvelle facture ?",
        ["account_name"] = "Compte: \"%{job_name}\"",
        ["send_a_bill"] = "• Envoyer une facture",
        ["cancel"] = "✖ Annuler",
        ["new_bill"] = "Nouvelle Facture",
        ["confirm"] = "Confirmer",
        ["recipient_server_id"] = "ID Destinataire (#)",
        ["amount"] = "Montant (€)",
        ["view_bills"] = "• Mes Factures",
        ["view_sent_bills"] = "• Factures Envoyées",
        ["send_new_bill"] = "• Nouvelle Facture",
        ["sent_bills"] = "Factures Envoyées",
        ["view_pending"] = "• Factures en attente",
        ["view_paid"] = "• Factures payées",
        ["return"] = "← Retour",
        ["your_bills"] = "Vos Factures",
        ["view_current_due"] = "• Factures a payer",
        ["view_past_paid"] = "• Anciennes Factures payés",
        ["are_you_sure_pay_bill_for"] = "Payer la facture de %{amount}€ ?",
        ["pay_bill_details"] = "Facture #%{bill_number}<br>Date: %{date}<br>Due à: %{sender_name} \"%{sender_acc}\"",
        ["take_me_back"] = "Retour",
        ["are_you_sure_cancel_bill_for"] = "Annuler la facture de %{amount}€ ?",
        ["cancel_bill_details_citizen"] = "Date: %{date}<br>Due à: %{sender_acc}<br>Destinataire: %{recipient_name} (%{citizenid})",
        ["owed_bills"] = "Factures dues",
        ["total_due"] = "Total due: %{amount}€",
        ["paid_bills"] = "Factures payées",
        ["total_paid"] = "Total payé: %{amount}€"
    },

    error = {
        ["sending_bill"] = "Erreur lors de l'envoi",
        ["not_permitted"] = "Vous n'avez pas le droit de facturer.",
        ["retrieving_bills"] = "Erreur de récupération",
        ["not_enough_money_in_bank"] = "Pas assez d'argent dans votre compte !",
        ["must_be_on_duty_and_authorized"] = "Vous devez etre autorisé et en service pour facturer dans le cadre de votre travail.",
        ["bill_already_paid"] = "Facture déja payée",
        ["error_getting_recipient_id"] = "Erreur de récupération ID destinataire",
        ["error_getting_bill_amount"] = "Erreur lors de la récupération montant de facture",
        ["error_getting_player_given_id"] = "Erreur, lors de la récupération d'utilisateur",
    },

    success = {
        ["bill_paid_by"] = "Facture #%{bill_number}: %{amount}€ payée par %{client}",
        ["bill_paid_to"] = "Facture #%{bill_number}: %{amount}€ payée à %{bill_sender} \"%{sender_acc}\"",
        ["amount_billed_to"] = "Montant: %{amount}€ facturé à %{firstname} %{lastname}",
        ["yes_send_bill_on_behalf_of"] = "Envoyer la facture pour le compte \"%{job_name}\" account.",
        ["yes_pay_it"] = "Payer la facture",
        ["yes_cancel_bill"] = "Annuler la facture"
    },

    historic = {
        ["bill"] = "#%{id} - %{amount}€",
        ["details"] = "Date: %{date}<br>Due à: \"%{sender_acc}\"<br>Destinataire: %{recipient_name} (%{citizenid})<br>Payée le: %{status_date}",
        ["details_less"] = "Date: %{date}<br>Due à: %{sender_name} \"%{sender_acc}\"",
        ["paid_bill_details"] = "Date: %{date}<br>Due à: %{sender_name} \"%{sender_acc}\"<br>Payée le: %{status_date}"

    },
}

if GetConvar('qb_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
