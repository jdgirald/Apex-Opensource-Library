/**
* MIT License
*
* Copyright (c) 2019 Piotr Kożuchowski
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/
@IsTest(IsParallel=true)
private class CaseSelectorTest {

    @TestSetup
    static void testSetup() {
        Account account = new Account(Name = 'Parent Account');
        insert account;

        insert new List<Case>{
                new Case(AccountId = account.Id, Subject = 'Subject 1', Status = 'New', Origin = 'Web'),
                new Case(AccountId = account.Id, Subject = 'Subject 2', Status = 'New', Origin = 'Web'),
                new Case(AccountId = account.Id, Subject = 'Subject 3', Status = 'New', Origin = 'Web')
        };
    }

    @IsTest
    static void testSelectWithParentAccount() {
        System.assertEquals('Parent Account',
                new CaseSelector()
                        .withParentAccount()
                        .bySubject(new List<String>{'Subject 1'})[0]
                        .Account.Name
        );
    }

    @IsTest
    static void testSelectBySubject() {
        SelectorTest.assertEquals(
                ([SELECT Id FROM Case WHERE Subject = 'Subject 1']),
                new CaseSelector().bySubject('Subject 1'));

        SelectorTest.assertEquals(
                ([SELECT Id FROM Case WHERE Subject IN ('Subject 1', 'Subject 2')]),
                new CaseSelector().bySubject(new List<String>{'Subject 1', 'Subject 2'}));
    }

    @IsTest
    static void testSelectByAccountId() {
        Account account = [SELECT Id FROM Account];

        SelectorTest.assertEquals(
                ([SELECT Id FROM Case WHERE AccountId = :account.Id]),
                new CaseSelector().byAccountId(account.Id));

        SelectorTest.assertEquals(
                ([SELECT Id FROM Case WHERE AccountId IN (:account.Id)]),
                new CaseSelector().byAccountId(new List<Id>{account.Id}));
    }
}