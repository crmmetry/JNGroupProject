public class CreditScoreController {
  @AuraEnabled
  public static decimal creditscorecalculation(
    string category,
    string Age1,
    string Education,
    string ResidentialStatus,
    string Yearsatcurrentresidence1,
    string CreditHistory1,
    string NetWorth,
    string EmploymentStatus,
    string IndustryofEmployment,
    string ProfessionalCategory,
    string Collateral,
    string LoantoValue1,
    string Abilitytoservice1,
    string RepaymentMethod,
    string LengthofCurrentEmployment1,
    string ProductSelection,
    String WorkingCapital,
    string NatureEngagement,
    string TypeIndustry,
    string FinancialPerformance,
    string FinancialSupport,
    string LengthTrade1,
    string PoliticallyExposed,
    string NegaticeTrace
  ) {
    system.debug('age========' + Age1);
    Decimal Age = Decimal.valueOf(Age1);
    Decimal LengthofCurrentEmployment = Decimal.valueOf(
      LengthofCurrentEmployment1
    );
    Decimal LoantoValue = Decimal.valueOf(LoantoValue1);
    Decimal Yearsatcurrentresidence = Decimal.valueOf(Yearsatcurrentresidence1);
    Decimal Abilitytoservice = Decimal.valueOf(Abilitytoservice1);
    Decimal CreditHistory = Decimal.valueOf(CreditHistory1);
    Decimal LengthTrade = Decimal.valueOf(LengthTrade1);

    decimal creditscore = 0;
    Credit_Calculation__mdt[] threatMappings = [
      SELECT
        Sub_Criteria__c,
        Sub_Criteria_Options__c,
        Employment_Type__c,
        Risk_Score__c,
        Weight_of_Sub_Criteria__c,
        Min__c,
        Max__c,
        Lower_Bound__c,
        Upper_Bound__c
      FROM Credit_Calculation__mdt
    ];
    decimal agescore = 0;
    decimal educationscore = 0;
    decimal Residentialscore = 0;
    decimal residenceYearscore = 0;
    decimal CreditHistoryscore = 0;
    decimal NetWorthscore = 0;
    decimal EmploymentStatusscore = 0;
    decimal IndustryofEmploymentscore = 0;
    decimal ProfessionalCategoryscore = 0;
    decimal Collateralscore = 0;
    decimal LoantoValuescore = 0;
    decimal AbilitytoServicescore = 0;
    decimal RepaymentMethodscore = 0;
    decimal LengthEmploymentscore = 0;
    decimal loantoweight = 0;
    decimal repaymentweight = 0;
    decimal repaymentriskscore = 0;
    decimal LengthTradescore = 0;
    decimal FinancialSupportscore = 0;
    decimal FinancialPerformancescore = 0;
    decimal TypeIndustryscore = 0;
    decimal NatureEngagementscore = 0;
    decimal WorkingCapitalscore = 0;

    for (Credit_Calculation__mdt cr : threatMappings) {
      if (ProductSelection == '2' && Collateral == 'None') {
        if (cr.Sub_Criteria__c == 'Loan to Value') {
          if (
            cr.Lower_Bound__c != null &&
            cr.Upper_Bound__c != null &&
            cr.Lower_Bound__c <= LoantoValue &&
            cr.Upper_Bound__c >= LoantoValue &&
            cr.Employment_Type__c == category
          ) {
            loantoweight = cr.Weight_of_Sub_Criteria__c;
          } else if (
            cr.Lower_Bound__c == null &&
            cr.Upper_Bound__c >= LoantoValue &&
            cr.Employment_Type__c == category
          ) {
            loantoweight = cr.Weight_of_Sub_Criteria__c;
          } else if (
            cr.Upper_Bound__c == null &&
            cr.Lower_Bound__c <= LoantoValue &&
            cr.Employment_Type__c == category
          ) {
            loantoweight = cr.Weight_of_Sub_Criteria__c;
          }
        }
        system.debug('loantoweight2========' + loantoweight);
        if (cr.Sub_Criteria__c == 'Repayment Method') {
          if (
            cr.Sub_Criteria_Options__c == RepaymentMethod &&
            cr.Employment_Type__c == category
          ) {
            repaymentriskscore = cr.Risk_Score__c != null
              ? cr.Risk_Score__c
              : 0;
            repaymentweight = cr.Weight_of_Sub_Criteria__c != null
              ? cr.Weight_of_Sub_Criteria__c
              : 0;
          }
        }
      }

      if (cr.Risk_Score__c != null && cr.Weight_of_Sub_Criteria__c != null) {
        if (cr.Sub_Criteria__c == 'Age') {
          if (
            cr.Lower_Bound__c != null &&
            cr.Upper_Bound__c != null &&
            cr.Lower_Bound__c <= Age &&
            cr.Upper_Bound__c >= Age &&
            cr.Employment_Type__c == category
          ) {
            system.debug('1========' + category);
            system.debug('agescore1========' + cr.Risk_Score__c);
            system.debug('agescore2========' + cr.Weight_of_Sub_Criteria__c);
            agescore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('agescore========' + agescore);
          } else if (
            cr.Lower_Bound__c == null &&
            cr.Upper_Bound__c >= Age &&
            cr.Employment_Type__c == category
          ) {
            system.debug('2========');
            agescore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('agescore========' + agescore);
          } else if (
            cr.Upper_Bound__c == null &&
            cr.Lower_Bound__c <= Age &&
            cr.Employment_Type__c == category
          ) {
            system.debug('3========');
            agescore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('agescore========' + agescore);
          }
        }

        if (cr.Sub_Criteria__c == 'Education') {
          if (
            cr.Sub_Criteria_Options__c == Education &&
            cr.Employment_Type__c == category
          ) {
            educationscore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('educationscore========' + educationscore);
          }
        }

        if (cr.Sub_Criteria__c == 'Residential Status') {
          if (
            cr.Sub_Criteria_Options__c == ResidentialStatus &&
            cr.Employment_Type__c == category
          ) {
            Residentialscore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('Residentialscore========' + Residentialscore);
          }
        }

        if (cr.Sub_Criteria__c == 'Years at current residence') {
          if (
            cr.Lower_Bound__c != null &&
            cr.Upper_Bound__c != null &&
            cr.Lower_Bound__c <= Yearsatcurrentresidence &&
            cr.Upper_Bound__c >= Yearsatcurrentresidence &&
            cr.Employment_Type__c == category
          ) {
            residenceYearscore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('residenceYearscore========' + residenceYearscore);
          } else if (
            cr.Lower_Bound__c == null &&
            cr.Upper_Bound__c >= Yearsatcurrentresidence &&
            cr.Employment_Type__c == category
          ) {
            residenceYearscore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('residenceYearscore========' + residenceYearscore);
          } else if (
            cr.Upper_Bound__c == null &&
            cr.Lower_Bound__c <= Yearsatcurrentresidence &&
            cr.Employment_Type__c == category
          ) {
            residenceYearscore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('residenceYearscore========' + residenceYearscore);
          }
        }
        system.debug('CreditHistory========' + CreditHistory);
        system.debug('CreditHistoryscore1========' + cr.Lower_Bound__c);
        system.debug('CreditHistoryscore2========' + cr.Upper_Bound__c);
        if (cr.Sub_Criteria__c == 'Credit History in last 24 Months') {
          if (
            cr.Lower_Bound__c != null &&
            cr.Upper_Bound__c != null &&
            cr.Lower_Bound__c <= CreditHistory &&
            cr.Upper_Bound__c >= CreditHistory &&
            cr.Employment_Type__c == category
          ) {
            CreditHistoryscore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('CreditHistoryscore========' + CreditHistoryscore);
          } else if (
            cr.Lower_Bound__c == null &&
            cr.Upper_Bound__c >= CreditHistory &&
            cr.Employment_Type__c == category
          ) {
            CreditHistoryscore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('CreditHistoryscore========' + CreditHistoryscore);
          } else if (
            cr.Upper_Bound__c == null &&
            cr.Lower_Bound__c <= CreditHistory &&
            cr.Employment_Type__c == category
          ) {
            CreditHistoryscore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('CreditHistoryscore========' + CreditHistoryscore);
          }
        }

        if (cr.Sub_Criteria__c == 'Net Worth') {
          if (
            cr.Sub_Criteria_Options__c == NetWorth &&
            cr.Employment_Type__c == category
          )
            NetWorthscore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
          system.debug('NetWorthscore========' + NetWorthscore);
        }

        if (category == 'Salaried') {
          if (cr.Sub_Criteria__c == 'Employment Status') {
            if (
              cr.Sub_Criteria_Options__c == EmploymentStatus &&
              cr.Employment_Type__c == category
            )
              EmploymentStatusscore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
            system.debug(
              'EmploymentStatusscore========' + EmploymentStatusscore
            );
          }

          if (cr.Sub_Criteria__c == 'Industry of Employment') {
            if (
              cr.Sub_Criteria_Options__c == IndustryofEmployment &&
              cr.Employment_Type__c == category
            )
              IndustryofEmploymentscore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
            system.debug(
              'IndustryofEmploymentscore========' + IndustryofEmploymentscore
            );
          }
          if (
            cr.Sub_Criteria__c == 'Length of Current Employment' &&
            cr.Risk_Score__c != null &&
            EmploymentStatus != 'Unemployed'
          ) {
            if (
              cr.Lower_Bound__c != null &&
              cr.Upper_Bound__c != null &&
              cr.Lower_Bound__c <= LengthofCurrentEmployment &&
              cr.Upper_Bound__c >= LengthofCurrentEmployment &&
              cr.Employment_Type__c == category
            ) {
              LengthEmploymentscore = percentagevalue(cr.Risk_Score__c, 4);
              system.debug(
                'LengthEmploymentscore========' + LengthEmploymentscore
              );
            } else if (
              cr.Lower_Bound__c == null &&
              cr.Upper_Bound__c >= LengthofCurrentEmployment &&
              cr.Employment_Type__c == category
            ) {
              LengthEmploymentscore = percentagevalue(cr.Risk_Score__c, 4);
              system.debug(
                'LengthEmploymentscore========' + LengthEmploymentscore
              );
            } else if (
              cr.Upper_Bound__c == null &&
              cr.Lower_Bound__c <= LengthofCurrentEmployment &&
              cr.Employment_Type__c == category
            ) {
              LengthEmploymentscore = percentagevalue(cr.Risk_Score__c, 4);
              system.debug(
                'LengthEmploymentscore========' + LengthEmploymentscore
              );
            }
          }

          if (
            cr.Sub_Criteria__c == 'Professional Category' &&
            EmploymentStatus != 'Unemployed'
          ) {
            if (
              cr.Sub_Criteria_Options__c == ProfessionalCategory &&
              cr.Employment_Type__c == category
            )
              ProfessionalCategoryscore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
            system.debug(
              'ProfessionalCategoryscore========' + ProfessionalCategoryscore
            );
          }
          if (
            cr.Sub_Criteria__c == 'Professional Category' &&
            EmploymentStatus == 'Unemployed'
          ) {
            if (
              cr.Sub_Criteria_Options__c == ProfessionalCategory &&
              cr.Employment_Type__c == category
            ) {
              Decimal loantoweightUn = cr.Weight_of_Sub_Criteria__c + 4;
              ProfessionalCategoryscore = percentagevalue(
                cr.Risk_Score__c,
                loantoweightUn
              );
            }
            system.debug(
              'ProfessionalCategoryscore========' + ProfessionalCategoryscore
            );
          }
        }

        if (cr.Sub_Criteria__c == 'Collateral') {
          if (
            cr.Sub_Criteria_Options__c == Collateral &&
            cr.Employment_Type__c == category
          )
            Collateralscore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
          system.debug('Collateralscore========' + Collateralscore);
        }

        if (
          cr.Sub_Criteria__c == 'Loan to Value' &&
          ProductSelection != '2' &&
          Collateral != 'None'
        ) {
          if (
            cr.Lower_Bound__c != null &&
            cr.Upper_Bound__c != null &&
            cr.Lower_Bound__c <= LoantoValue &&
            cr.Upper_Bound__c >= LoantoValue &&
            cr.Employment_Type__c == category
          ) {
            LoantoValuescore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('LoantoValuescore========' + LoantoValuescore);
          } else if (
            cr.Lower_Bound__c == null &&
            cr.Upper_Bound__c >= LoantoValue &&
            cr.Employment_Type__c == category
          ) {
            LoantoValuescore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug('LoantoValuescore========' + LoantoValuescore);
          } else if (
            cr.Upper_Bound__c == null &&
            cr.Lower_Bound__c <= LoantoValue &&
            cr.Employment_Type__c == category
          ) {
            LoantoValuescore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug(
              'loantoweight3========' + cr.Weight_of_Sub_Criteria__c
            );
            system.debug('LoantoValuescore========' + LoantoValuescore);
          }
        }

        if (cr.Sub_Criteria__c == 'Ability to Service') {
          if (
            cr.Lower_Bound__c != null &&
            cr.Upper_Bound__c != null &&
            cr.Lower_Bound__c <= Abilitytoservice &&
            cr.Upper_Bound__c >= Abilitytoservice &&
            cr.Employment_Type__c == category
          ) {
            AbilitytoServicescore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug(
              'AbilitytoServicescore========' + AbilitytoServicescore
            );
          } else if (
            cr.Lower_Bound__c == null &&
            cr.Upper_Bound__c >= Abilitytoservice &&
            cr.Employment_Type__c == category
          ) {
            AbilitytoServicescore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug(
              'AbilitytoServicescore========' + AbilitytoServicescore
            );
          } else if (
            cr.Upper_Bound__c == null &&
            cr.Lower_Bound__c <= Abilitytoservice &&
            cr.Employment_Type__c == category
          ) {
            AbilitytoServicescore = percentagevalue(
              cr.Risk_Score__c,
              cr.Weight_of_Sub_Criteria__c
            );
            system.debug(
              'AbilitytoServicescore========' + AbilitytoServicescore
            );
          }
        }
        system.debug('pavit========' + RepaymentMethod);
        system.debug('pavit1========' + category);
        //====================================
        if (cr.Sub_Criteria__c == 'Repayment Method') {
          system.debug('pavit2========');
          if (ProductSelection != '2' && Collateral != 'None') {
            if (
              cr.Sub_Criteria_Options__c == RepaymentMethod &&
              cr.Employment_Type__c == category
            ) {
              RepaymentMethodscore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
              system.debug(
                'RepaymentMethodscore========' + RepaymentMethodscore
              );
            }
          }
        }
        //===========================
        //=====self-employed====
        if (category == 'Self-Employed') {
          if (cr.Sub_Criteria__c == 'Working Capital') {
            system.debug('WorkingCapital========' + WorkingCapital);
            system.debug(
              'WorkingCapitalcr.Risk_Score__c========' + cr.Risk_Score__c
            );
            system.debug(
              'WorkingCapitalcr.Weight_of_Sub_Criteria__c========' +
              cr.Weight_of_Sub_Criteria__c
            );
            if (
              cr.Sub_Criteria_Options__c == WorkingCapital &&
              cr.Employment_Type__c == category
            )
              WorkingCapitalscore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
            system.debug('WorkingCapitalscore========' + WorkingCapitalscore);
          }
          if (cr.Sub_Criteria__c == 'Nature of Engagement') {
            if (
              cr.Sub_Criteria_Options__c == NatureEngagement &&
              cr.Employment_Type__c == category
            )
              NatureEngagementscore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
            system.debug(
              'NatureEngagementscore========' + NatureEngagementscore
            );
          }
          if (cr.Sub_Criteria__c == 'Type of Industry') {
            if (
              cr.Sub_Criteria_Options__c == TypeIndustry &&
              cr.Employment_Type__c == category
            )
              TypeIndustryscore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
            system.debug('TypeIndustryscore========' + TypeIndustryscore);
          }
          if (cr.Sub_Criteria__c == 'Financial Performance') {
            if (
              cr.Sub_Criteria_Options__c == FinancialPerformance &&
              cr.Employment_Type__c == category
            )
              FinancialPerformancescore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
            system.debug(
              'FinancialPerformancescore========' + FinancialPerformancescore
            );
          }
          if (cr.Sub_Criteria__c == 'Financial Statement Support') {
            if (
              cr.Sub_Criteria_Options__c == FinancialSupport &&
              cr.Employment_Type__c == category
            )
              FinancialSupportscore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
            system.debug(
              'FinancialSupportscore========' + FinancialSupportscore
            );
          }
          if (cr.Sub_Criteria__c == 'Length of Trade') {
            if (
              cr.Lower_Bound__c != null &&
              cr.Upper_Bound__c != null &&
              cr.Lower_Bound__c <= LengthTrade &&
              cr.Upper_Bound__c > LengthTrade &&
              cr.Employment_Type__c == category
            ) {
              LengthTradescore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
              system.debug('LengthTradescore1========' + LengthTradescore);
            } else if (
              cr.Lower_Bound__c == null &&
              cr.Upper_Bound__c > LengthTrade &&
              cr.Employment_Type__c == category
            ) {
              LengthTradescore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
              system.debug('LengthTradescore2========' + LengthTradescore);
            } else if (
              cr.Upper_Bound__c == null &&
              cr.Lower_Bound__c <= LengthTrade &&
              cr.Employment_Type__c == category
            ) {
              LengthTradescore = percentagevalue(
                cr.Risk_Score__c,
                cr.Weight_of_Sub_Criteria__c
              );
              system.debug('LengthTradescore3========' + LengthTradescore);
            }
          }
        }
      }
    }
    if (ProductSelection == '2' && Collateral == 'None') {
      decimal weight = loantoweight + repaymentweight;
      RepaymentMethodscore = percentagevalue(repaymentriskscore, weight);
      system.debug('RepaymentMethodscore========' + RepaymentMethodscore);
    }

    system.debug('agescore========k' + agescore);
    system.debug('educationscore========k' + educationscore);
    system.debug('Residentialscore========k' + Residentialscore);
    system.debug('residenceYearscore========k' + residenceYearscore);
    system.debug('CreditHistoryscore========k' + CreditHistoryscore);
    system.debug('NetWorthscore========k' + NetWorthscore);
    system.debug('EmploymentStatusscore========k' + EmploymentStatusscore);
    system.debug(
      'IndustryofEmploymentscore========k' + IndustryofEmploymentscore
    );
    system.debug(
      'ProfessionalCategoryscore========k' + ProfessionalCategoryscore
    );
    system.debug('Collateralscore========k' + Collateralscore);
    system.debug('LoantoValuescore========k' + LoantoValuescore);
    system.debug('AbilitytoServicescore========k' + AbilitytoServicescore);
    system.debug('RepaymentMethodscore========k' + RepaymentMethodscore);
    system.debug('LengthEmploymentscore========k' + LengthEmploymentscore);
    system.debug('LengthTradescore========k' + LengthTradescore);
    system.debug('FinancialSupportscore========k' + FinancialSupportscore);
    system.debug(
      'FinancialPerformancescore========k' + FinancialPerformancescore
    );
    system.debug('TypeIndustryscore========k' + TypeIndustryscore);
    system.debug('NatureEngagementscore========k' + NatureEngagementscore);
    system.debug('WorkingCapitalscore========k' + WorkingCapitalscore);

    creditscore =
      agescore +
      educationscore +
      Residentialscore +
      residenceYearscore +
      CreditHistoryscore +
      NetWorthscore +
      EmploymentStatusscore +
      IndustryofEmploymentscore +
      ProfessionalCategoryscore +
      Collateralscore +
      LoantoValuescore +
      AbilitytoServicescore +
      RepaymentMethodscore +
      LengthEmploymentscore +
      LengthTradescore +
      FinancialSupportscore +
      FinancialPerformancescore +
      TypeIndustryscore +
      NatureEngagementscore +
      WorkingCapitalscore;
    system.debug('creditscore========' + creditscore);
    if (
      NegaticeTrace == '0' ||
      PoliticallyExposed == '0' ||
      CreditHistory == 91
    ) {
      if (creditscore < 479)
        creditscore = 479;
      if (creditscore > 556)
        creditscore = 556;
    }
    decimal creditscore1 = creditscore.round(System.RoundingMode.HALF_UP);
    return creditscore1;
  }
  private static Decimal percentagevalue(Decimal score, decimal percentage) {
    decimal val = (score * percentage) / 100;
    return val;
  }
  @AuraEnabled
  public static string SaveCreditScoreapex(string oppId, string Score) {
    string result;

    try {
      Opportunity opp = [
        SELECT Id, AccountId
        FROM Opportunity
        WHERE Id = :oppId
        LIMIT 1
      ];

      Account acc = new Account();
      acc.Id = opp.AccountId;
      acc.FinServ__CreditScore__c = Decimal.valueof(Score);
      update acc;

      result = 'Success';
    } catch (exception ex) {
      result = 'Error';
    }
    system.debug('result=====' + result);
    return result;
  }
  public decimal getAbilitytoService(
    list<FinServ__AssetsAndLiabilities__c> assetlst,
    list<Applicant__c> applst,
    Decimal totalincome
  ) {
    // list<Account> acclist

    Decimal TDSR = 0;
    Decimal totalmonthlypayment = 0;
    /*
         * Decimal AutoTDSR=0;
        Decimal UnsecuredTDSR=0;
        Decimal CCTDSR=0;
        Decimal LOCTDSR=0;map<string, string> tdsrmap= new map<string, string>();
         Decimal Autototalprice=0;
        Decimal Unsecuredtotalprice=0;
        Decimal CCtotalprice=0;
        Decimal LOCtotalprice=0;
        Decimal totalincome=0;
        for(Account acc:acclist){
            totalincome +=acc.Gross_Monthly_Income__pc!=null?acc.Gross_Monthly_Income__pc:0;
        }
        if(opplinelst.size()>0){
            for(opportunityLineitem ol:opplinelst){
                if(ol.Product2.Name =='JN Bank Auto Loan'){// 'Auto Loan';
                    Autototalprice=ol.TotalPrice;
                    decimal Autoasset=opp.Collateral__r.Monthly_Payment_Calc__c!=null?opp.Collateral__r.Monthly_Payment_Calc__c:0;
                    system.debug('Autototalprice==>'+Autototalprice);
                    system.debug('Autoasset==>'+Autoasset);
                    system.debug('totalincome==>'+totalincome);
                    if(totalincome>0)
                        AutoTDSR=(Autototalprice+Autoasset)/totalincome;
                }
                if(ol.Product2.Name =='JN Bank Unsecured Loan'){// 'Unsecured Loan';
                    Unsecuredtotalprice=ol.TotalPrice;
                    decimal Unsecuredasset=opp.Unsecured_Assets_and_Liabilities__r.Monthly_Payment_Calc__c!=null?opp.Unsecured_Assets_and_Liabilities__r.Monthly_Payment_Calc__c:0;
                    if(totalincome>0)
                        UnsecuredTDSR=(Unsecuredtotalprice+Unsecuredasset)/totalincome;
                }
                if(ol.Product2.Name =='JN Visa - Classic'){// 'Credit Card';
                    CCtotalprice=ol.TotalPrice;
                    decimal ccasset=opp.Collateral_Personal_Credit_Card__r.Minimum_Payment__c!=null?opp.Collateral_Personal_Credit_Card__r.Minimum_Payment__c:0;
                    if(totalincome>0)
                        CCTDSR=(CCtotalprice+ccasset)/totalincome;
                }
                if(ol.Product2.Name =='JN Bank Line Of Credit'){// 'Line of Credit';
                    LOCtotalprice=ol.TotalPrice;
                    decimal locasset=opp.Collateral_Personal_Line_of_Credit__r.Minimum_Payment__c!=null?opp.Collateral_Personal_Line_of_Credit__r.Minimum_Payment__c:0;
                    if(totalincome>0)
                        LOCTDSR=(LOCtotalprice+locasset)/totalincome;
                }
            }
        }*/
    for (FinServ__AssetsAndLiabilities__c al : assetlst) {
      totalmonthlypayment += al.Monthly_Payment_Prior__c;
    }
    for (Applicant__c app : applst) {
      totalmonthlypayment +=
        app.Rent_Board_Monthly_Prior_Loan__c +
        app.Strata_Maintenance_Monthly_Prior_Loan__c;
    }
    /* tdsrmap.put('TDSR',string.valueof(AutoTDSR));
        tdsrmap.put('UnsecuredTDSR',string.valueof(UnsecuredTDSR));
        tdsrmap.put('CCTDSR',string.valueof(CCTDSR));
        tdsrmap.put('LOCTDSR',string.valueof(LOCTDSR));*/
    TDSR = totalmonthlypayment / totalincome;
    return TDSR;
  }
  public map<string, Decimal> getLoantoValue(Loan_Calculator__c lc) {
    /*  
       system.debug('Test## Loan to value called ===>opp='+opp+'===Product='+Productname+'====TotalPrice='+TotalPrice);
        system.debug('Test## Loan to value called ===>opp.Collateral__r.Account_Balance__c='+opp.Collateral__r.Account_Balance__c+'===opp.Collateral__r.Total_Market_Value_Calc__c='+opp.Collateral__r.Total_Market_Value_Calc__c);
        decimal loan2value=0;
        if((Productname=='Auto' || Productname=='Credit' || Productname=='LineofCredit') && TotalPrice>0){
            if(opp!=null){
                decimal totalassets=0;              
                if(Productname=='Auto')
                    totalassets=(opp.Collateral__r.Account_Balance__c!=null?opp.Collateral__r.Account_Balance__c:0)+(opp.Collateral__r.Total_Market_Value_Calc__c!=null?opp.Collateral__r.Total_Market_Value_Calc__c:0);
                if(Productname=='Credit')
                    totalassets=(opp.Collateral_Personal_Credit_Card__r.Account_Balance__c!=null?opp.Collateral_Personal_Credit_Card__r.Account_Balance__c:0)+(opp.Collateral_Personal_Credit_Card__r.Total_Market_Value_Calc__c!=null?opp.Collateral_Personal_Credit_Card__r.Total_Market_Value_Calc__c:0);
                if(Productname=='LineofCredit')
                    totalassets=(opp.Collateral_Personal_Line_of_Credit__r.Account_Balance__c!=null?opp.Collateral_Personal_Line_of_Credit__r.Account_Balance__c:0)+(opp.Collateral_Personal_Line_of_Credit__r.Total_Market_Value_Calc__c!=null?opp.Collateral_Personal_Line_of_Credit__r.Total_Market_Value_Calc__c:0);
                system.debug('Test## totalassets='+totalassets+'==='+Productname);
                system.debug('Test## TotalPrice='+TotalPrice);
                if(totalassets>0)
                    loan2value=TotalPrice/totalassets;
                system.debug('Test## Loan to value called ===>loan2value='+loan2value);
            }
        }*/
    Decimal AutoLC = 0;
    Decimal CCLC = 0;
    Decimal LOCLC = 0;

    if (
      lc.Total_Loan_Amount__c != null &&
      lc.Market_Value_of_Vehicle__c != null
    )
      AutoLC = lc.Total_Loan_Amount__c / lc.Market_Value_of_Vehicle__c;
    if (
      lc.Proposed_Starting_Limit__c != null &&
      lc.PC_Deposit_Account_Balance__c != null
    )
      CCLC = lc.Proposed_Starting_Limit__c / lc.PC_Deposit_Account_Balance__c;
    if (
      lc.Line_of_Credit_Starting_Limit__c != null &&
      lc.PCL_Deposit_Account_Balance__c != null
    )
      LOCLC =
        lc.Line_of_Credit_Starting_Limit__c / lc.PCL_Deposit_Account_Balance__c;
    map<string, Decimal> lcmap = new Map<string, Decimal>();
    lcmap.put('AutoLC', AutoLC);
    lcmap.put('CCLC', CCLC);
    lcmap.put('LOCLC', LOCLC);
    return lcmap;
  }
}
