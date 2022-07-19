/**
 * Created by lhegyi on 7/15/2022.
 */

public with sharing class AccountTriggerHandler
{

    public class ResponseWrapper{

        public List<Person> results;
    }

    public class Person{
        public Name name;
    }

    public class Name{
        public String first;
        public String last;
        public String title;
    }

    @Future(Callout=true)
    public static void AttachNewRandomContact(Set<Id> newaccs)
    {
        String nat = 'gb';
        Integer resoultNum = newaccs.size();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://randomuser.me/api/?nat=' + nat + '&results' + resoultNum);
        req.setMethod('GET');
        HttpResponse response = new Http().send(req);
        System.debug('response:'+response.getBody());
        ResponseWrapper wrapper = (ResponseWrapper) JSON.deserialize(response.getBody(),ResponseWrapper.class);
        List<Id> accIds = new List<Id>(newaccs);
        List<Contact> contacts = new List<Contact>();
        for(Integer i =0;i<wrapper.results.size();i++)
        {
            contacts.add(new Contact(
                    AccountId=accIds.get(i),
                    FirstName = wrapper.results.get(i).name.first,
                    LastName = wrapper.results.get(i).name.last,
                    Title = wrapper.results.get(i).name.title,
                    MailingCity = 'Budapest',
                    MailingCountry = 'Hungary',
                    MailingStreet = 'Sport'
            ));
        }
        insert contacts;

    }


    public static void handleAfterInsert(Map<Id,Account> accounts)
    {
        AttachNewRandomContact(accounts.keySet());
    }

}