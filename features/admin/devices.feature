Feature: Device Management
  In order to whitelist devices that can communicate with the server
  As an admin / superadmin
  I need to an interface to manage the whitelist devices

  Scenario: List devices with imei and registered date sorted by imei
    Given I logged in  as 'admin'
    And following devices exists
      |imei            | registered_date  |
      |123456789012345 | March 09, 2012   |
      |123456789012341 | March 09, 2012   |
      |123456789012342 | March 09, 2012   |
    When I follow devices page
    Then I should see the devices with imei and registered date sorted by  imei

  Scenario: List 10 devices per page
    Given I logged in  as 'admin'
    And 30 devices exists
    When I follow devices page
    Then I should see 10 devices in first page
    And I should see pagination with links for 3 pages
    And I should see a drop down with options to change number of records per page

  Scenario: Option to view 10/25/50/100 devices per page instantly
    Given I logged in  as 'admin'
    And 130 devices exists
    And I am on devices page
    When I choose '50' devices per page dropdown
    Then I should see 50 devices per page withouot page refresh
    And I should pagination for 2 pages
    And I should see the devices are sorted by imei

  Scenario: Option to search devices by imei or registered date instantly
    Given I logged in  as 'admin'
    And following devices exists
      |imei            | registered_date  |
      |123456789012345 | March 09, 2012   |
      |123456789012346 | March 09, 2012   |
      |123456789012347 | March 09, 2012   |
      |123456789012348 | March 09, 2012   |
      |123456789012349 | March 09, 2012   |
    And I am on devices page
    When I search device by &#x27;IDSD2342342&#x27;
    Then I should see all the above devices instantly without page refresh

  Scenario:5 Option to sort devices by imei or registered date instantly
    Given I logged in  as 'admin'
    And following devices exists
      |imei            | registered_date  |
      |123456789012345 | March 09, 2012   |
      |123456789012346 | March 03, 2012   |
      |123456789012347 | March 04, 2012   |
      |123456789012348 | March 01, 2012   |
      |123456789012349 | March 01, 2012   |
    And I am on devices page
    When I sort devices by 'Registered Date'
    Then I should see devices in following order instantly without page refresh
      |imei            | registered_date  |
      |123456789012348 | March 01, 2012   |
      |123456789012349 | March 01, 2012   |
      |123456789012346 | March 03, 2012   |
      |123456789012347 | March 04, 2012   |
      |123456789012345 | March 09, 2012   |

  Scenario: Add new device
    Given today is 'Sep 12, 2012 13:00:00 PM'
    And I my name is 'James'
    And I logged in as 'admin'
    And I add following device
      |imei            | registered_date  |
      |123456789012345 | March 01, 2012   |
    Then I should see the device in the list page
    When I visit detail page
    Then I should see the following logs
    |Date                  |Action details                     | User who perform this action |
    |Sep 12, 2012 13:00:00 |Device: 123456789012345 is created | James                        |

  Scenario: Update a device
    Given today is 'Sep 12, 2012 13:00:00 PM'
    And I my name is 'James'
    And I logged in  as 'admin'
    And following device exist

      |imei            | registered_date  |
      |123456789012345 | March 01, 2012   |
    When I update device 'imei' from '123456789012345' to '123456789012346'
    And  I update 'registered date' from 'March 01, 2012' to 'March 08, 2012'
    Then I should see the changes in the device list page
    When I visit the device detail page
    Then the following logs should be displayed
      |Date                         | Sep 12, 2012 13:00:00                                             |
      |Action details               | Device: 123456789012345 is updated with Imei:123456789012345 and  |
      |User who perform this action | Registered Date 'March 08, 2012'                                  |

  Scenario: Remove a device
    Given today is 'Sep 12, 2012 13:00:00 PM'
    And I my name is 'James'
    And I logged in  as 'admin'
    And I following device exist
      |imei            | registered_date  |
      |123456789012345 | March 01, 2012   |
    When I remove the device '123456789012345'
    Then I should not see the device in the list page
    But the device should not be removed from the database
    And the device 'deleted_at' value should be set around 'Sep 12, 2012 13:00:00'
    And the following log should be added
      |Date                         | Sep 12, 2012 13:00:00                                             |
      |Action details               | Device: 123456789012345 is updated with Imei:123456789012345 and  |
      |User who perform this action | Registered Date 'March 08, 2012'                                  |

  Scenario: Device cannot use another device's imei
    Given I logged in  as 'admin'
    And I following device exist
      |imei            | registered_date  |
      |123456789012345 | March 01, 2012   |
    When I add new device with imei '123456789012345'
    Then I should see 'imei has already been taken' error message

  Scenario: Device can use another removed device's imei
    Given I logged in as 'admin'
    And I following device exist
      |imei            | registered date  |
      |123456789012345 | March 01, 2012   |
    When I removed the device '123456789012345'
    And I add new device with imei '123456789012345'
    Then I should see the device added in the device list

  Scenario: Device can use another removed device's imei
    Given I logged in as 'admin'
    And I following device exist
      |imei            | registered date  |
      |123456789012345 | March 01, 2012   |
    When I removed the device '123456789012345'
    And I add new device with imei '123456789012345'
    Then I should see the device added in the device list

  Scenario Outline: Validations while adding new device
    Given I logged in as 'admin'
    And no device exists
    When I add new device
    And I fill 'imei' with '<imei>'
    And I fill 'registered_date' with '<registered_date>'
    Then I should see '<imei_error>' message for 'imei' field
    And I should see '<regdate_error>' message for 'registration_date' field
    Examples:
    |imei              | registered_date | imei_error             | regdate_error   |
    |                  |                 | cannot be blank        | cannot be blank |
    | 21312312313      | 30/3/222        | is invalid             | is invalid      |
    | 1234567890123451 | 21/02/2012      | is invalid             |                 |
    | 123456789012345  | 30/3/222        |                        | is invalid      |
    | 12345678901234A  | 20/02/2012      | is invalid             |                 |
    | 123456789012345  | 20/02/2012      |                        |                 |
    | 123456789012345  | 21/02/2012      | has already been taken |                 |

  Scenario Outline: Validations while updating an device
    Given I logged in as 'admin'
    And following devices exists
      |imei            | registered_date  |
      |123456789012345 | March 01, 2012   |
      |123456789012346 | March 01, 2012   |
    When I edit device '123456789012345'
    And I fill 'imei' with '<imei>'
    And I fill 'registered_date' with '<registered_date>'
    Then I should see '<imei_error>' message for 'imei' field
    And I should see '<regdate_error>' message for 'registration_date' field

  Examples:
  |imei              | registered_date | imei_error             | regdate_error   |
  |                  |                 | cannot be blank        | cannot be blank |
  | 21312312313      | 30/3/222        | is invalid             | is invalid      |
  | 1234567890123451 | 21/02/2012      | is invalid             |                 |
  | 123456789012345  | 30/3/222        |                        | is invalid      |
  | 12345678901234A  | 20/02/2012      | is invalid             |                 |
  | 123456789012345  | 20/02/2012      |                        |                 |
  | 123456789012346  | 21/02/2012      | has already been taken |                 |
