/**
* MIT License
*
* Copyright (c) 2018 Piotr Kożuchowski
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
@IsTest
private class HttpSimpleMockTest {

    @IsTest
    static void testSimpleJsonMock() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('www.acme.com/rest/auth');


        Test.startTest();
        Test.setMock(HttpCalloutMock.class, HttpSimpleMock.fromJSON(200, 'OK', new Map<String, String>{'refresh_token' => 'XXX'}));
        HttpResponse response = new Http().send(request);
        Test.stopTest();


        System.assertEquals('{"refresh_token":"XXX"}', response.getBody());
    }

    @IsTest
    static void testSimpleStaticResourceMockCoverage() {
        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('www.acme.com/rest/auth');


            Test.startTest();
            Test.setMock(HttpCalloutMock.class, HttpSimpleMock.fromStaticResource(200, 'OK', 'HttpSimpleMockTest'));
            HttpResponse response = new Http().send(request);
            Test.stopTest();


        } catch (Exception e) {
        }
    }
}