//
//  SourceList.swift
//  Stripe
//
//  Created by Anthony Castelli on 4/20/17.
//
//

/**
 Sources list
 https://stripe.com/docs/api#customer_object-sources
 */

public typealias StripeSourcesList = StripeList<StripePaymentSource>

extension StripeList where Model == StripePaymentSource {
    
    public var bankAccounts: [StripeBankAccount] {
        return data.compactMap { $0.bankAccount }
    }
    
    public var cards: [StripeCard] {
        return data.compactMap { $0.card }
    }
    
    public var sources: [StripeSource] {
        return data.compactMap { $0.source }
    }
}
