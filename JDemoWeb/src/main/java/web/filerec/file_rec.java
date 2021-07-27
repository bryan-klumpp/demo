package web.filerec;

import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.transaction.Transactional;

import web.DBUtil;
import web.DbOperation;

//@ComponentScan(basePackages = { "weblib" })
@Entity
@Table(name="file_rec")
//@PropertySource({ "classpath:META-INF/persistence.xml" })
//@org.springframework.data.relational.core.mapping.Table("file_rec")
public class file_rec {
	public static final String SALES_DB = "SalesDB";
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	private String bKey;
	
	
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	private String path;

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getbKey() {
		return bKey;
	}

	public void setbKey(String bKey) {
		this.bKey = bKey;
	}

//	public static void ff_RefreshFileNameCache() {
//		
//		ff_deleteAll();
//		
//		DraftCommands.refreshBKEYS_PROPS_FILE(SystemB.DEFAULT_SYSTEM_OUT_PRINTWRITER);
//		
//		for(String key : StringUtil.stringIterable(SelfNameIndexedFiles.getBKEYS().keySet()) ) {
//			String path = SelfNameIndexedFiles.getBKEYS().getProperty(key);
//			file_rec rec = new file_rec();
//			rec.setbKey(key);
//			rec.setPath(path);
//			DBUtil.newRow(rec, SALES_DB);
//		}
//	}

	@Transactional
	public static void ff_deleteAll() {
//		FileRecService.getRepository().deleteAll(); //silently failing??
		
		DBUtil.dbExec(new DbOperation() {
			
			@Override
			public void run(EntityManager em) {
				em.createQuery("delete from file_rec").executeUpdate();
			}
		}, SALES_DB);
		
//		DBUtil.getQuery("delete from file_rec").executeUpdate(); //needs transaaction
		
	}
	@Override
	public String toString() {
		return getPath();
	}

}
