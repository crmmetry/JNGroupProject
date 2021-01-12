@isTest
public class TestComparator {
  @TestSetup
  public static void setup() {
    User newUser = TestDataFactory.CreateUser('ta@test.com');
    insert newUser;
  }

  @isTest
  public static void shouldCompareWorkerObject() {
    User u = [SELECT Id FROM USER WHERE UserName = 'ta@test.com'];
    Worker a = new Worker(u.Id, 5, 'Jamaica');
    Worker b = new Worker(u.id, 5, 'Kingston');
    SkillComparator skill_comp = new SkillComparator();
    Integer result = skill_comp.compare(a, b);
  }

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
}
