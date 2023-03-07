# frozen_string_literal: true

module Prodamus
  NON_INSTALLMENTS_PAYMENT_METHODS = %w[
    AC ACkz ACkztjp ACf ACeuruk ACusduk ACEURNMBX
    ACUSDNMBX SBP PC QW GP sbol invoice
  ].freeze

  INSTALLMENTS_PAYMENT_METHODS = %w[
    installment installment_5_21 installment_6_28
    installment_10_28 installment_12_28 installment_0_0_3
    installment_0_0_4 installment_0_0_6 installment_0_0_10
    installment_0_0_12 installment_0_0_24 credit
    vsegdada_installment_0_0_4 vsegdada_installment_0_0_6 vsegdada_installment_0_0_10
    vsegdada_installment_0_0_12 vsegdada_installment_0_0_24
  ].freeze

  ALL_AVAIBLE_PAYMENT_METHODS = NON_INSTALLMENTS_PAYMENT_METHODS + INSTALLMENTS_PAYMENT_METHODS
end
