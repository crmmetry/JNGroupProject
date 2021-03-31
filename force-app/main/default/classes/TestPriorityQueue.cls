/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 03-19-2021
 * @last modified by  : Remario Richards
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   03-19-2021   Remario Richards   Initial Version
 **/
@isTest
public class TestPriorityQueue {
  @TestSetup
  public static void setup() {
    User newUser = TestDataFactory.CreateUser('produser12@test.com');
    insert newUser;
  }

  @isTest
  public static void shouldCreatePriorityQueue() {
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    System.assert(prio_queue != null, 'Queue not made!');
  }

  @isTest
  public static void shouldCreatePriorityQueue2() {
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class,
      5
    );
    System.assert(prio_queue != null, 'Queue not made!');
  }

  @isTest
  public static void shouldGetSizeOfQueue() {
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    Integer sizeOfQueue = prio_queue.size();
    System.assert(sizeOfQueue == 0, 'Size of Queue is Invalid');
  }

  @isTest
  public static void shouldGetPeek() {
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    prio_queue.offer(a);
    System.assert(prio_queue.size() > 0, 'Queue is empty');
    //prio_queue.contains(a);
    Object b = prio_queue.peek();
  }

  @isTest
  public static void shouldAddElementToQueueAndPoll() {
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    prio_queue.add(a);
    prio_queue.poll();
  }

  @isTest
  public static void shouldAddMultipleElementsToQueueAndClear() {
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    for (Integer i = 0; i < 3; i++) {
      Worker a = new Worker(u.Id, 5, 'Jamaica');
      prio_queue.add(a);
    }
    Worker a = new Worker(u.Id, 1, 'America');
    Object b = prio_queue.add(a);
    System.assert(b != null, 'Poll is empty!');
    prio_queue.clear();
  }

  @isTest
  public static void shouldAddMultipleElementsToQueueAndPoll() {
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    for (Integer i = 0; i < 3; i++) {
      Worker a = new Worker(u.Id, 5, 'Jamaica');
      prio_queue.add(a);
    }
    Worker a = new Worker(u.Id, 1, 'America');
    prio_queue.add(a);
    prio_queue.poll();
  }

  @isTest
  public static void shouldThrowContainsException() {
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    prio_queue.offer(a);
    try {
      System.assert(prio_queue.size() > 0, 'Queue is empty');
      prio_queue.contains(a);
    } catch (UnsupportedOperationException e) {
      Boolean expectedExceptionThrown = e.getMessage()
          .contains('Contains is not supported by queues.')
        ? true
        : false;
      System.AssertEquals(
        expectedExceptionThrown,
        true,
        'Error message was thrown!'
      );
    }
  }

  @isTest
  public static void shouldRemoveElement() {
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    prio_queue.add(a);
    prio_queue.remove(a);
  }

  @isTest
  public static void shouldReturnArrayOfAQueue() {
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    prio_queue.add(a);
    Object[] arr = prio_queue.toArray();
  }

  @isTest
  public static void shouldContains() {
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    try {
      test_queue.data.add(a);
      Boolean result = test_queue.contains(a);
    } catch (Exception e) {
      System.assert(e.getMessage().length() > 0, e.getMessage());
      System.assertEquals(
        'Contains is not supported by queues.',
        e.getMessage(),
        e.getMessage()
      );
    }
  }

  @isTest
  public static void shouldContainsWhenFalse() {
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    try {
      //test_queue.data.add(a);
      Boolean result = test_queue.contains(a);
    } catch (Exception e) {
      System.assert(e.getMessage().length() > 0, e.getMessage());
      System.assertEquals(
        'Contains is not supported by queues.',
        e.getMessage(),
        e.getMessage()
      );
    }
  }

  @isTest
  public static void shouldTestContainsAllWhenFalse() {
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    TestQueue test_queue2 = new TestQueue(TestPriorityQueue.Worker.class);
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    Worker b = new Worker(u.Id, 10, 'Kingston');
    Worker c = new Worker(u.Id, 15, 'Barbican');
    test_queue.add(a);
    test_queue.add(b);
    test_queue.add(c);
    try {
      Boolean result = test_queue.containsAll(test_queue2);
    } catch (Exception e) {
      System.assert(e.getMessage().length() > 0, e.getMessage());
      System.assertEquals(
        'Contains is not supported by queues.',
        e.getMessage(),
        e.getMessage()
      );
    }
  }

  @isTest
  public static void shouldTestContainsAllWhenTrue() {
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    PriorityQueue prio_queue2 = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    Worker b = new Worker(u.Id, 10, 'Kingston');
    prio_queue.add(a);
    //prio_queue2.add(b);
    try {
      Boolean result = prio_queue2.containsAll(prio_queue);
      System.assert(result, 'Contains All result is not false');
    } catch (Exception e) {
      System.assert(e.getMessage().length() > 0, e.getMessage());
      System.assertEquals(
        'Contains is not supported by queues.',
        e.getMessage(),
        e.getMessage()
      );
    }
  }

  @isTest
  public static void shouldAddAllElementsOfAQueue() {
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    PriorityQueue prio_queue2 = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    prio_queue.add(a);
    Boolean result = prio_queue2.addAll(prio_queue);
    System.assert(result, 'Queue was not added or modified');
  }

  @isTest
  public static void shouldGetIterator() {
    PriorityQueue prio_queue = new PriorityQueue(
      new SkillComparator(),
      TestPriorityQueue.Worker.class
    );
    Iterator<Object> queueIterator = prio_queue.iterator();
  }

  @isTest
  public static void shouldGetTypeNull() {
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    Object o = null;
    String typeResult = test_queue.getType(o);
    System.assert(typeResult == '', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeString() {
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String o = 'null';
    String typeResult = test_queue.getType(o);
    System.assert(typeResult == 'String', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeSObject() {
    Account acc = new Account();
    //insert acc;
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String typeResult = test_queue.getType(acc);
    System.assert(typeResult == 'Account', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeBoolean() {
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    Boolean test_boolean = true;
    String typeResult = test_queue.getType(test_boolean);
    System.assert(typeResult == 'Boolean', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeId() {
    Account acc = TestDataFactory.CreateBasicAccounts(1, 'ln')[0];
    insert acc;
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String typeResult = test_queue.getType(acc.Id);
    System.assert(typeResult == 'Id', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeBlob() {
    Blob test_blob = Blob.valueOf('test');
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String typeResult = test_queue.getType(test_blob);
    System.assert(typeResult == 'Blob', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeDate() {
    Date today_date = Date.today();
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String typeResult = test_queue.getType(today_date);
    System.assert(typeResult == 'Date', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeDateTime() {
    DateTime today_datetime = System.now();
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String typeResult = test_queue.getType(today_datetime);
    System.assert(typeResult == 'DateTime', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeTime() {
    Time test_time = Time.newInstance(1, 2, 3, 4);
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String typeResult = test_queue.getType(test_time);
    System.assert(typeResult == 'Time', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeInteger() {
    Integer num = 1;
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String typeResult = test_queue.getType(num);
    System.assert(typeResult == 'Integer', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeLong() {
    Long long_var = 2147483648L;
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String typeResult = test_queue.getType(long_var);
    System.assert(typeResult == 'Long', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeDecimal() {
    Decimal decimal_var = 0.01234;
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String typeResult = test_queue.getType(decimal_var);
    System.assert(typeResult == 'Decimal', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeListObject() {
    List<Integer> nums = new List<Integer>();
    for (Integer i = 0; i < 3; i++) {
      nums.add(i);
    }
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String typeResult = test_queue.getType(nums);
    System.assert(typeResult == 'List', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldGetTypeSet() {
    Set<Integer> nums = new Set<Integer>();
    for (Integer i = 0; i < 3; i++) {
      nums.add(i);
    }
    TestQueue test_queue = new TestQueue(TestPriorityQueue.Worker.class);
    String typeResult = test_queue.getType(nums);
    System.assert(typeResult == 'Object', 'Type returned is incorrect');
  }

  @isTest
  public static void shouldTestAbstractQueueOfferMethod() {
    TestQueue2 test_queue = new TestQueue2(TestPriorityQueue.Worker.class);
    User u = [SELECT Id FROM USER WHERE UserName = 'produser12@test.com'];
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    Boolean result = test_queue.offer(a);
    System.assert(result, 'Offer method returns false');
    System.assert(test_queue != null, 'Element was not added to queue');
  }

  /***    Supplementary Classes    ***/
  class Worker implements Comparable {
    public Id userId;
    public Integer workLoad;
    public String location;
    public Worker(Id userId, Integer workLoad, String location) {
      this.location = location;
      this.workLoad = workLoad;
      this.userId = userId;
    }

    public void updateWorkLoad() {
      this.workLoad = this.workLoad + 1;
    }
    public void setWorkLoad(Integer value) {
      this.workLoad = value;
    }
    public Integer compareTo(Object work) {
      if (workLoad < ((Worker) work).workLoad)
        return -1;
      else if (workLoad > ((Worker) work).workLoad)
        return 1;
      return 0;
    }
  }

  class SkillComparator implements Comparator {
    public Integer compare(Object a, Object b) {
      return ((Worker) a).compareTo((Worker) b);
    }
  }

  class TestQueue extends AbstractCollection {
    private final List<Object> data;

    public TestQueue(Type t) {
      super(t);
      data = new List<Object>();
    }

    public override Integer size() {
      return data.size();
    }

    public override Iterator<Object> iterator() {
      return data.iterator();
    }

    public override Boolean remove(final Object o) {
      //throw new UnsupportedOperationException();
      return false;
    }

    public override void clear() {
    }

    public override Boolean contains(final Object o) {
      return super.contains(o);
    }

    public override String getType(final Object o) {
      return super.getType(o);
    }
  }

  class TestQueue2 extends AbstractQueue {
    private final List<Object> data;

    public TestQueue2(Type t) {
      super(t);
      data = new List<Object>();
    }

    public override Integer size() {
      return data.size();
    }

    public override Iterator<Object> iterator() {
      return data.iterator();
    }

    public override String getType(final Object o) {
      return super.getType(o);
    }

    public override Object poll() {
      Object o;
      return o;
    }

    public override Object peek() {
      return data[0];
    }
  }
}
