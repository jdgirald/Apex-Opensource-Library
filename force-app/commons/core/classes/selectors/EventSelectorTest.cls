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
public with sharing class EventSelectorTest {

    @TestSetup
    static void testSetup() {
        Account account = new Account(Name = 'Parent Account');
        insert account;

        Contact contact = new Contact(LastName = 'Doe', AccountId = account.Id);
        insert contact;

        insert new Event[]{
                new Event(Subject = 'Test',
                        ActivityDateTime = Datetime.now(),
                        EndDateTime = Datetime.now().addHours(12),
                        WhatId = account.Id,
                        WhoId = contact.Id)
        };
    }

    @IsTest
    static void testSelectByAccountId() {
        Account account = [SELECT Id FROM Account];

        SelectorTest.assertEquals(
                ([SELECT Id FROM Event WHERE AccountId = :account.Id]),
                new EventSelector().byAccountId(account.Id)
        );
        SelectorTest.assertEquals(
                ([SELECT Id FROM Event WHERE AccountId = :account.Id]),
                new EventSelector().byAccountId(new List<Id>{account.Id})
        );
    }

    @IsTest
    static void testSelectByWhatId() {
        Account account = [SELECT Id FROM Account];

        SelectorTest.assertEquals(
                ([SELECT Id FROM Event WHERE WhatId = :account.Id]),
                new EventSelector().byWhatId(account.Id)
        );
        SelectorTest.assertEquals(
                ([SELECT Id FROM Event WHERE WhatId = :account.Id]),
                new EventSelector().byWhatId(new List<Id>{account.Id})
        );
    }

    @IsTest
    static void testSelectByWhoId() {
        Contact contact = [SELECT Id FROM Contact WHERE LastName = 'Doe'];

        SelectorTest.assertEquals(
                ([SELECT Id FROM Event WHERE WhoId = :contact.Id]),
                new EventSelector().byWhoId(contact.Id)
        );
        SelectorTest.assertEquals(
                ([SELECT Id FROM Event WHERE WhoId = :contact.Id]),
                new EventSelector().byWhoId(new List<Id>{contact.Id})
        );
    }
}