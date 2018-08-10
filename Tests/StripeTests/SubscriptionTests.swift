//
//  SubscriptionTests.swift
//  Stripe
//
//  Created by Andrew Edwards on 6/10/17.
//
//

import XCTest
@testable import Stripe
@testable import Vapor

class SubscriptionTests: XCTestCase {
    func testSubscriptionParsedProperly() throws {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            let body = HTTPBody(string: subscriptionString)
            var headers: HTTPHeaders = [:]
            headers.replaceOrAdd(name: .contentType, value: MediaType.json.description)
            let request = HTTPRequest(headers: headers, body: body)
            let subscription = try decoder.decode(StripeSubscription.self, from: request, maxSize: 65_536, on: EmbeddedEventLoop())

            subscription.do({ (sub) in
                
                // This test covers the Discount object
                XCTAssertNotNil(sub.discount)
                XCTAssertEqual(sub.discount?.object, "discount")
                XCTAssertEqual(sub.discount?.customer, "cus_CCMIISleHrbPlY")
                XCTAssertEqual(sub.discount?.end, Date(timeIntervalSince1970: 1399384361))
                XCTAssertEqual(sub.discount?.start, Date(timeIntervalSince1970: 1391694761))
                XCTAssertEqual(sub.discount?.subscription, "sub_12345")
                
                // This test covers the Coupon object
                XCTAssertNotNil(sub.discount?.coupon)
                XCTAssertEqual(sub.discount?.coupon.id, "35OFF")
                XCTAssertEqual(sub.discount?.coupon.object, "coupon")
                XCTAssertEqual(sub.discount?.coupon.amountOff, 5)
                XCTAssertEqual(sub.discount?.coupon.created, Date(timeIntervalSince1970: 1391694467))
                XCTAssertEqual(sub.discount?.coupon.currency, .usd)
                XCTAssertEqual(sub.discount?.coupon.duration, .repeating)
                XCTAssertEqual(sub.discount?.coupon.durationInMonths, 3)
                XCTAssertEqual(sub.discount?.coupon.livemode, false)
                XCTAssertEqual(sub.discount?.coupon.maxRedemptions, 22)
                XCTAssertEqual(sub.discount?.coupon.metadata["hello"], "world")
                XCTAssertEqual(sub.discount?.coupon.percentOff, 25)
                XCTAssertEqual(sub.discount?.coupon.redeemBy, Date(timeIntervalSince1970: 1489793908))
                XCTAssertEqual(sub.discount?.coupon.timesRedeemed, 1)
                XCTAssertEqual(sub.discount?.coupon.valid, true)
                
                // This test covers the Subscription item list object
                XCTAssertNotNil(sub.items)
                XCTAssertEqual(sub.items.object, "list")
                XCTAssertEqual(sub.items.hasMore, false)
                XCTAssertEqual(sub.items.totalCount, 1)
                XCTAssertEqual(sub.items.url, "/v1/subscription_items?subscription=sub_AJ6s2Iy65K3RxN")
                
                // This test covers the SubscriptionItem  object
                XCTAssertNotNil(sub.items.data)
                XCTAssertNotNil(sub.items.data[0])
                XCTAssertEqual(sub.items.data[0].id, "si_19yUeQ2eZvKYlo2CnJwkz3pK")
                XCTAssertEqual(sub.items.data[0].object, "subscription_item")
                XCTAssertEqual(sub.items.data[0].created, Date(timeIntervalSince1970: 1489793911))
                XCTAssertEqual(sub.items.data[0].metadata["hello"], "world")
                XCTAssertEqual(sub.items.data[0].quantity, 1)
                XCTAssertEqual(sub.items.data[0].subscription, "sub_AJ6s2Iy65K3RxN")
                
                // These cover the Plan object
                XCTAssertNotNil(sub.items.data[0].plan)
                XCTAssertEqual(sub.items.data[0].plan.id, "30990foo1489793903")
                XCTAssertEqual(sub.items.data[0].plan.object, "plan")
                XCTAssertEqual(sub.items.data[0].plan.amount, 100)
                XCTAssertEqual(sub.items.data[0].plan.created, Date(timeIntervalSince1970: 1489793908))
                XCTAssertEqual(sub.items.data[0].plan.currency, .usd)
                XCTAssertEqual(sub.items.data[0].plan.interval, .week)
                XCTAssertEqual(sub.items.data[0].plan.intervalCount, 1)
                XCTAssertEqual(sub.items.data[0].plan.livemode, false)
                XCTAssertEqual(sub.items.data[0].plan.metadata["hello"], "world")
                XCTAssertEqual(sub.items.data[0].plan.nickname, "Foo")
                XCTAssertEqual(sub.items.data[0].plan.product, "prod_1234")
                XCTAssertEqual(sub.items.data[0].plan.transformUsage?.divideBy, 5)
                XCTAssertEqual(sub.items.data[0].plan.transformUsage?.round, .up)
                XCTAssertEqual(sub.items.data[0].plan.trialPeriodDays, 3)

                // These cover the Plan object
                XCTAssertNotNil(sub.items.data[1].plan)
                XCTAssertEqual(sub.items.data[1].plan.amount, nil)
                XCTAssertEqual(sub.items.data[1].plan.tiers?[0].amount, 0)
                XCTAssertEqual(sub.items.data[1].plan.tiers?[0].upTo, 1)
                XCTAssertEqual(sub.items.data[1].plan.tiers?[1].amount, 200)
                XCTAssertEqual(sub.items.data[1].plan.tiers?[1].upTo, nil)
                XCTAssertEqual(sub.items.data[1].plan.tiersMode, .graduated)
                
                // These cover the Plan object
                XCTAssertNotNil(sub.plan)
                XCTAssertEqual(sub.plan?.id, "30990foo1489793903")
                XCTAssertEqual(sub.plan?.object, "plan")
                XCTAssertEqual(sub.plan?.billingScheme, .perUnit)
                XCTAssertEqual(sub.plan?.usageType, .metered)
                XCTAssertEqual(sub.plan?.active, false)
                XCTAssertEqual(sub.plan?.amount, 100)
                XCTAssertEqual(sub.plan?.created, Date(timeIntervalSince1970: 1489793908))
                XCTAssertEqual(sub.plan?.currency, .usd)
                XCTAssertEqual(sub.plan?.interval, .week)
                XCTAssertEqual(sub.plan?.intervalCount, 1)
                XCTAssertEqual(sub.plan?.livemode, false)
                XCTAssertEqual(sub.plan?.metadata["hello"], "world")
                XCTAssertEqual(sub.plan?.nickname, "Foo")
                XCTAssertEqual(sub.plan?.product, "prod_1234")
                XCTAssertEqual(sub.plan?.trialPeriodDays, 14)
                
                XCTAssertEqual(sub.id, "sub_AJ6s2Iy65K3RxN")
                XCTAssertEqual(sub.object, "subscription")
                XCTAssertEqual(sub.applicationFeePercent, 12.7)
                XCTAssertEqual(sub.billing, "charge_automatically")
                XCTAssertEqual(sub.billingCycleAnchor, Date(timeIntervalSince1970: 1490398710))
                XCTAssertEqual(sub.cancelAtPeriodEnd, false)
                XCTAssertEqual(sub.canceledAt, Date(timeIntervalSince1970: 1489793914))
                XCTAssertEqual(sub.created, Date(timeIntervalSince1970: 1489793910))
                XCTAssertEqual(sub.currentPeriodEnd, Date(timeIntervalSince1970: 1490398710))
                XCTAssertEqual(sub.currentPeriodStart, Date(timeIntervalSince1970: 1489793910))
                XCTAssertEqual(sub.customer, "cus_CCMIISleHrbPlY")
                XCTAssertEqual(sub.daysUntilDue, 4)
                XCTAssertEqual(sub.endedAt, Date(timeIntervalSince1970: 1489793914))
                XCTAssertEqual(sub.livemode, true)
                XCTAssertEqual(sub.metadata["foo"], "bar")
                XCTAssertEqual(sub.quantity, 1)
                XCTAssertEqual(sub.start, Date(timeIntervalSince1970: 1489793910))
                XCTAssertEqual(sub.status, StripeSubscriptionStatus.pastDue)
                XCTAssertEqual(sub.taxPercent, 4.5)
                XCTAssertEqual(sub.trialEnd, Date(timeIntervalSince1970: 1489793910))
                XCTAssertEqual(sub.trialStart, Date(timeIntervalSince1970: 1489793910))
            }).catch({ (error) in
                XCTFail("\(error)")
            })
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    let subscriptionString = """
{
  "id": "sub_AJ6s2Iy65K3RxN",
  "object": "subscription",
  "application_fee_percent": 12.7,
  "billing": "charge_automatically",
  "billing_cycle_anchor": 1490398710,
  "cancel_at_period_end": false,
  "canceled_at": 1489793914,
  "created": 1489793910,
  "current_period_end": 1490398710,
  "current_period_start": 1489793910,
  "customer": "cus_CCMIISleHrbPlY",
  "days_until_due": 4,
  "discount": {
      "object": "discount",
      "coupon": {
        "id": "35OFF",
        "object": "coupon",
        "amount_off": 5,
        "created": 1391694467,
        "currency": "usd",
        "duration": "repeating",
        "duration_in_months": 3,
        "livemode": false,
        "max_redemptions": 22,
        "metadata": {
            "hello": "world"
        },
        "percent_off": 25,
        "redeem_by": 1489793908,
        "times_redeemed": 1,
        "valid": true
      },
      "customer": "cus_CCMIISleHrbPlY",
      "end": 1399384361,
      "start": 1391694761,
      "subscription": "sub_12345"
    },
  "ended_at": 1489793914,
  "items": {
    "object": "list",
    "data": [
      {
        "id": "si_19yUeQ2eZvKYlo2CnJwkz3pK",
        "object": "subscription_item",
        "created": 1489793911,
        "metadata": {
            "hello": "world"
        },
        "plan": {
          "id": "30990foo1489793903",
          "object": "plan",
          "amount": 100,
          "active": false,
          "billing_scheme": "per_unit",
          "usage_type": "metered",
          "created": 1489793908,
          "currency": "usd",
          "interval": "week",
          "interval_count": 1,
          "livemode": false,
          "metadata": {
            "hello": "world"
          },
          "nickname": "Foo",
          "product": "prod_1234",
          "transform_usage": {
            "divide_by": 5,
            "round": "up"
          },
          "trial_period_days": 3
        },
        "quantity": 1,
        "subscription": "sub_AJ6s2Iy65K3RxN"
      },
      {
        "id": "si_DKeuh94LM6FNyn",
        "object": "subscription_item",
        "created": 1533050240,
        "metadata": {
        },
        "plan": {
          "id": "plan_DIkuyHGrZFW7DN",
          "object": "plan",
          "active": true,
          "aggregate_usage": null,
          "amount": null,
          "billing_scheme": "tiered",
          "created": 1532611277,
          "currency": "usd",
          "interval": "week",
          "interval_count": 1,
          "livemode": false,
          "metadata": {
          },
          "nickname": "Bar",
          "product": "prod_DIksc7vKNkuiw3",
          "tiers": [
            {
              "amount": 0,
              "up_to": 1
            },
            {
              "amount": 200,
              "up_to": null
            }
          ],
          "tiers_mode": "graduated",
          "transform_usage": null,
          "trial_period_days": null,
          "usage_type": "licensed"
        },
        "quantity": 8,
        "subscription": "sub_DKeur6TMKSqZqB"
      }
    ],
    "has_more": false,
    "total_count": 1,
    "url": "/v1/subscription_items?subscription=sub_AJ6s2Iy65K3RxN"
  },
  "livemode": true,
  "metadata": {
    "foo": "bar"
  },
  "plan": {
    "id": "30990foo1489793903",
    "object": "plan",
    "amount": 100,
    "active": false,
    "billing_scheme": "per_unit",
    "usage_type": "metered",
    "created": 1489793908,
    "currency": "usd",
    "interval": "week",
    "interval_count": 1,
    "livemode": false,
    "metadata": {
        "hello": "world"
    },
    "nickname": "Foo",
    "product": "prod_1234",
    "trial_period_days": 14
  },
  "quantity": 1,
  "start": 1489793910,
  "status": "past_due",
  "tax_percent": 4.5,
  "trial_end": 1489793910,
  "trial_start": 1489793910
}
"""
}
