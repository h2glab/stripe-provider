//
//  StripeList.swift
//  Stripe
//
//  Created by Nicolas Bachschmidt on 2018-08-09.
//

/**
 Pagninated list of objects
 https://stripe.com/docs/api#pagination
 */

public struct StripeList<Model>: StripeModel where Model: StripeModel {
    public var object: String
    public var hasMore: Bool
    public var totalCount: Int
    public var url: String
    public var data: [Model]
    
    public enum CodingKeys: String, CodingKey {
        case object
        case hasMore = "has_more"
        case totalCount = "total_count"
        case url
        case data
    }
}

extension StripeList: Sequence {
    
    public func makeIterator() -> IndexingIterator<[Model]> {
        return data.makeIterator()
    }
}
