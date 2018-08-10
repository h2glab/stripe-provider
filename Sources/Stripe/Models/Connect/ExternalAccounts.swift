//
//  ExternalAccounts.swift
//  Stripe
//
//  Created by Andrew Edwards on 7/8/17.
//
//

/**
 External accounts list
 https://stripe.com/docs/api/curl#account_object-external_accounts
 */

public typealias ExternalAccountsList = StripeList<StripePaymentSource>

public protocol ExternalAccount {}
