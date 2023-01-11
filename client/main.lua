QBCore = exports['qb-core']:GetCoreObject()

-- Functions --

local function comma_value(amount)
    local formatted = amount

    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end

    return formatted
end

local function engageConfirmBillMenu(billAmount, recipient)
    local recCharInfo = recipient.PlayerData.charinfo
    local menu = {
        {
            header = Lang:t("info.are_you_sure_want_send_bill"),
            isMenuHeader = true,
            txt = Lang:t("success.amount_billed_to", {amount = comma_value(billAmount), firstname = recCharInfo.firstname, lastname = recCharInfo.lastname})
        },
        {
            header = Lang:t("info.no_changed_mind"),
            params = {
                event = exports['qb-menu']:closeMenu()
            }
        },
        {
            -- header = 'Yes, send this bill on behalf of the "' .. QBCore.Functions.GetPlayerData().job.name .. '" account.',
            header = Lang:t("success.yes_send_bill_on_behalf_of", {job_name = QBCore.Functions.GetPlayerData().job.name}),
            params = {
                isServer = true,
                event = 'billing:server:sendBill',
                args = {
                    billAmount = billAmount,
                    recipient = recipient
                }
            }
        },
    }

    exports['qb-menu']:openMenu(menu)
end

local function engageSendBillMenu()
    local senderData = QBCore.Functions.GetPlayerData()
    local menu = {
        {
            header = Lang:t("info.do_you_want_to_send_bill"),
            isMenuHeader = true,
            txt = Lang:t("info.account_name", {job_name = senderData.job.name})
        },
        {
            header = Lang:t("info.send_a_bill"),
            params = {
                event = 'billing:client:createBill'
            }
        },
        {
            header = Lang:t("info.return"),
            params = {
                event = 'billing:client:engageChooseBillViewMenu'
            }
        },
        {
            header = Lang:t("info.cancel"),
            params = {
                event = exports['qb-menu']:closeMenu()
            }
        },
    }

    exports['qb-menu']:openMenu(menu)
end

-- Commands --

RegisterCommand(Config.BillingCommand, function()
    TriggerEvent('billing:client:engageChooseBillViewMenu')
end)

-- Events --

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('billing:server:RequestCommands')
end)

RegisterNetEvent('billing:client:RequestCommands', function(isAllowed)
    if isAllowed then
        TriggerServerEvent('chat:addSuggestion', '/' .. Config.BillingCommand, {})
    end
end)

RegisterNetEvent('billing:client:canSendBill', function()
    QBCore.Functions.TriggerCallback('billing:server:canSendBill', function(canSendBill)
        if canSendBill then
            engageSendBillMenu()
        else
            QBCore.Functions.Notify(Lang:t("error.must_be_on_duty_and_authorized"), 'error')
        end
    end)
end)

RegisterNetEvent('billing:client:notifyOfPaidBill', function()
    QBCore.Functions.Notify(Lang:t("error.bill_already_paid"), 'error')
end)

RegisterNetEvent('billing:client:createBill', function()
    local recipientID = nil
    local billAmount = nil

    local input = exports['qb-input']:ShowInput({
        header = Lang:t("info.new_bill"),
        submitText = Lang:t("info.confirm"),
        inputs = {
            {
                text = Lang:t("info.recipient_server_id"),
                name = "id",
                type = "number",
                isRequired = true
            },
            {
                text = Lang:t("info.amount"),
                name = "amount",
                type = "number",
                isRequired = true
            }
        },
    })
    recipientID = input.id
    billAmount = input.amount

    if not recipientID then
        QBCore.Functions.Notify(Lang:t("error.error_getting_recipient_id"), 'error')
        return
    end

    if not billAmount then
        QBCore.Functions.Notify(Lang:t("error.error_getting_bill_amount"), 'error')
        return
    end

    QBCore.Functions.TriggerCallback('billing:server:getPlayerFromId', function(validRecipient)
        if validRecipient then
            engageConfirmBillMenu(billAmount, validRecipient)
        else
            QBCore.Functions.Notify(Lang:t("error.error_getting_player_given_id"), 'error')
        end
    end, recipientID)
end)

RegisterNetEvent('billing:client:engageChooseBillViewMenu', function()
    local menu = {
        {
            header = 'Options',
            isMenuHeader = true
        },
        {
            header = Lang:t("info.view_bills"),
            params = {
                event = 'billing:client:engageChooseYourBillsViewMenu'
            }
        },
        {
            header = Lang:t("info.view_sent_bills"),
            params = {
                event = 'billing:client:engageChooseSentBillsViewMenu'
            }
        },
        {
            header = Lang:t("info.send_new_bill"),
            params = {
                event = 'billing:client:canSendBill'
            }
        },
        {
            header = Lang:t("info.cancel"),
            params = {
                event = exports['qb-menu']:closeMenu()
            }
        },
    }

    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('billing:client:engageChooseSentBillsViewMenu', function()
    local menu = {
        {
            header = Lang:t("info.sent_bills"),
            isMenuHeader = true
        },
        {
            header = Lang:t("info.view_pending"),
            params = {
                isServer = true,
                event = 'billing:server:getPendingBilled'
            }
        },
        {
            header = Lang:t("info.view_paid"),
            params = {
                isServer = true,
                event = 'billing:server:getPaidBilled'
            }
        },
        {
            header = Lang:t("info.return"),
            params = {
                event = 'billing:client:engageChooseBillViewMenu'
            }
        },
        {
            header = Lang:t("info.cancel"),
            params = {
                event = exports['qb-menu']:closeMenu()
            }
        },
    }

    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('billing:client:engageChooseYourBillsViewMenu', function()
    local menu = {
        {
            header = Lang:t("info.your_bills"),
            isMenuHeader = true
        },
        {
            header = Lang:t("info.view_current_due"),
            params = {
                isServer = true,
                event = 'billing:server:getBillsToPay'
            }
        },
        {
            header = Lang:t("info.view_past_paid"),
            params = {
                isServer = true,
                event = 'billing:server:getPaidBills'
            }
        },
        {
            header = Lang:t("info.return"),
            params = {
                event = 'billing:client:engageChooseBillViewMenu'
            }
        },
        {
            header = Lang:t("info.cancel"),
            params = {
                event = exports['qb-menu']:closeMenu()
            }
        },
    }

    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('billing:client:openConfirmPayBillMenu', function(data)
    local bill = data.bill
    local billsMenu = {
        {
            header = Lang:t("info.are_you_sure_pay_bill_for", {amount = comma_value(bill.amount)}),
            isMenuHeader = true,
            txt = Lang:t("info.pay_bill_details", {bill_number = bill.id, date = bill.bill_date, sender_name = bill.sender_name, sender_acc = bill.sender_account})
        },
        {
            header = Lang:t("info.take_me_back"),
            params = {
                isServer = true,
                event = 'billing:server:getBillsToPay'
            }
        },
        {
            header = Lang:t("success.yes_pay_it"),
            params = {
                isServer = true,
                event = 'billing:server:payBill',
                args = {
                    bill = bill
                }
            }
        }
    }

    exports['qb-menu']:openMenu(billsMenu)
end)

RegisterNetEvent('billing:client:openConfirmCancelBillMenu', function(data)
    local bill = data.bill
    local billsMenu = {
        {
            header = Lang:t("info.are_you_sure_cancel_bill_for", {amount = comma_value(bill.amount)}),
            isMenuHeader = true,
            txt = Lang:t("info.cancel_bill_details_citizen", {date = bill.bill_date, sender_acc = bill.sender_account, recipient_name = bill.recipient_name, citizenid = bill.recipient_citizenid})
        },
        {
            header = Lang:t("info.take_me_back"),
            params = {
                isServer = true,
                event = 'billing:server:getPendingBilled'
            }
        },
        {
            header = Lang:t("success.yes_cancel_bill"),
            params = {
                isServer = true,
                event = 'billing:server:deleteBill',
                args = {
                    bill = bill
                }
            }
        }
    }

    exports['qb-menu']:openMenu(billsMenu)
end)

RegisterNetEvent('billing:client:openPendingBilledMenu', function(bills)
    local ordered_keys = {}
    local totalDue = 0

    for k, v in pairs(bills) do
        table.insert(ordered_keys, k)
        totalDue = totalDue + v.amount
    end

    table.sort(ordered_keys)

    local billsMenu = {
        {
            header = 'Bills Owed',
            isMenuHeader = true,
            txt = 'Total Due: $' .. comma_value(totalDue) .. ''
        }
    }

    for i = #ordered_keys, 1, -1 do
        local v = bills[i]
        billsMenu[#billsMenu + 1] = {
            header = '#' .. v.id .. ' - $' .. comma_value(v.amount) .. '',
            txt = Lang:t("info.cancel_bill_details_citizen", {date = v.bill_date, sender_acc = v.sender_account, recipient_name = v.recipient_name, citizenid = v.recipient_citizenid}),
            params = {
                event = 'billing:client:openConfirmCancelBillMenu',
                args = {
                    bill = v
                }
            }
        }
    end
    billsMenu[#billsMenu + 1] = {
        header = Lang:t("info.return"),
        params = {
            event = 'billing:client:engageChooseSentBillsViewMenu'
        }
    }
    billsMenu[#billsMenu + 1] = {
        header = Lang:t("info.cancel"),
        params = {
            event = 'qb-menu:client:closeMenu'
        }
    }

    exports['qb-menu']:openMenu(billsMenu)
end)

RegisterNetEvent('billing:client:openPaidBilledMenu', function(bills)
    local ordered_keys = {}
    local totalPaid = 0

    for k, v in pairs(bills) do
        table.insert(ordered_keys, k)
        totalPaid = totalPaid + v.amount
    end

    table.sort(ordered_keys)

    local billsMenu = {
        {
            header = 'Bills Paid',
            isMenuHeader = true,
            txt = 'Total Paid: $' .. comma_value(totalPaid) .. ''
        }
    }

    for i = #ordered_keys, 1, -1 do
        local v = bills[i]
        billsMenu[#billsMenu + 1] = {
            header = Lang:t("historic.bill", {id = v.id, amount = comma_value(v.amount)}),
            txt = Lang:t("historic.details", {date = v.bill_date, sender_acc = v.sender_account, recipient_name = v.recipient_name, citizenid = v.recipient_citizenid, status_date = v.status_date}),
            params = {
                event = 'billing:client:notifyOfPaidBill'
            }
        }
    end
    billsMenu[#billsMenu + 1] = {
        header = Lang:t("info.return"),
        params = {
            event = 'billing:client:engageChooseSentBillsViewMenu'
        }
    }
    billsMenu[#billsMenu + 1] = {
        header = Lang:t("info.cancel"),
        params = {
            event = 'qb-menu:client:closeMenu'
        }
    }

    exports['qb-menu']:openMenu(billsMenu)
end)

RegisterNetEvent('billing:client:openBillsToPayMenu', function(bills)
    local ordered_keys = {}
    local totalDue = 0

    for k, v in pairs(bills) do
        table.insert(ordered_keys, k)
        totalDue = totalDue + v.amount
    end

    table.sort(ordered_keys)

    local billsMenu = {
        {
            header = Lang:t("info.owed_bills"),
            isMenuHeader = true,
            txt = Lang:t("info.total_due", {amount = comma_value(totalDue)})
        }
    }

    for i = #ordered_keys, 1, -1 do
        local v = bills[i]
        billsMenu[#billsMenu + 1] = {
            header = Lang:t("historic.bill", {id = v.id, amount = comma_value(v.amount)}),
            txt = Lang:t("historic.details_less", {date = v.bill_date, sender_name = v.sender_name, sender_acc = v.sender_account}),
            params = {
                event = 'billing:client:openConfirmPayBillMenu',
                args = {
                    bill = v
                }
            }
        }
    end
    billsMenu[#billsMenu + 1] = {
        header = Lang:t("info.return"),
        params = {
            event = 'billing:client:engageChooseYourBillsViewMenu'
        }
    }
    billsMenu[#billsMenu + 1] = {
        header = Lang:t("info.cancel"),
        params = {
            event = 'qb-menu:client:closeMenu'
        }
    }

    exports['qb-menu']:openMenu(billsMenu)
end)

RegisterNetEvent('billing:client:openPaidBillsMenu', function(bills)
    local ordered_keys = {}
    local totalPaid = 0

    for k, v in pairs(bills) do
        table.insert(ordered_keys, k)
        totalPaid = totalPaid + v.amount
    end

    table.sort(ordered_keys)

    local billsMenu = {
        {
            header = Lang:t("info.paid_bills"),
            isMenuHeader = true,
            txt = Lang:t("info.total_paid", {amount = comma_value(totalPaid)})
        }
    }

    for i = #ordered_keys, 1, -1 do
        local v = bills[i]
        billsMenu[#billsMenu + 1] = {
            header = Lang:t("historic.bill", {id = v.id, amount = comma_value(v.amount)}),
            txt = Lang:t("historic.paid_bill_details", {date = v.bill_date, sender_name = v.sender_name, sender_acc = v.sender_account, status_date = v.status_date}),
            params = {
                event = 'billing:client:notifyOfPaidBill'
            }
        }
    end
    billsMenu[#billsMenu + 1] = {
        header = Lang:t("info.return"),
        params = {
            event = 'billing:client:engageChooseYourBillsViewMenu'
        }
    }
    billsMenu[#billsMenu + 1] = {
        header = Lang:t("info.cancel"),
        params = {
            event = 'qb-menu:client:closeMenu'
        }
    }

    exports['qb-menu']:openMenu(billsMenu)
end)