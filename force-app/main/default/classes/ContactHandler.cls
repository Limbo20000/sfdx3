/**
 * Created by lhegyi on 7/5/2022.
 */

public with sharing class ContactHandler
{
    public void UpdateContact(List<Account> accs)
    {
        List<Contact> tobeupdated = new List<Contact>();
        for(Account acc:accs)
        {
            if(acc.ActiveChk__c == false)
            {
                for (Contact contacts :acc.contacts)
                {
                    contacts.Active__c = false;
                    contacts.Title = acc.Description;
                    acc.BillingState = '';
                    tobeupdated.add(contacts);
                }
                //Database.update(acc.Contacts,false);

            }
        }


        List<Database.SaveResult> db=Database.update(accs,true);
        System.debug(db);
    }
}