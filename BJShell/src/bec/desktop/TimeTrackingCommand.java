package bec.desktop;

import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class TimeTrackingCommand extends CmdBase {

	TimeTrackingCommand(PrintWriter w) { super(w); }
	
	@Override
	public void exec(List<String> args) {
    	PrintWriter writer = getWriter();
        if (args.isEmpty()) {
            sopInProgress();
            return;
        }

        boolean allowParallel = false;
        Integer i = null;
        Boolean isNew = null;
        String desc = null;
        Timestamp startTs = null;
        Timestamp endTs = null;
        Float pct = null;

        for (int j = 0; j < args.size(); j++) {
            String arg = args.get(j);
            /*if (arg.matches("switch")) {
                allowParallel = false;
                continue;
            }
            if (arg.matches("parallel")) {
                allowParallel = true;
                continue;
            }
            if (arg.matches("last")) {
                i = Q.i("select max(i) from do_log");
                isNew = false;
                continue;
            }
            if (arg.matches("0|1|\\.\\d{1,5}")) { //note we match 0 and 1 so this should come before the check for i
               pct = new Float(arg);
                continue;
            }
            if (arg.matches("\\d{1,5}")) {
                i = new Integer(arg);
                isNew = false;
                continue;
            }
            if (S.eq(arg, "start")) {
                if (j < (args.size() - 1) && timestamp(args.get(j + 1), false, false) != null) {

                    j++; //NOTE special case skip ahead

                    startTs = timestamp(args.get(j), true, false);
                } else {
                    startTs = new Timestamp(System.currentTimeMillis());
                }
                continue;
            }
            if (S.eq(arg, "end")) {
				if(true)return; //abort, we aren't doing endings anymore
                if (j < (args.size() - 1) && timestamp(args.get(j + 1), false, false) != null) {

                    j++; //NOTE special case skip ahead

                    endTs = timestamp(args.get(j), true, false);
                } else {
                    endTs = new Timestamp(System.currentTimeMillis());
                }
                continue;
            }*/
            Timestamp ts = B.timestamp(arg, false, false);
            if (ts != null) {
                if (startTs == null) {
                    startTs = ts;
                } else {
                    endTs = ts;
                }
                continue;
            }
            desc = arg; //if nothing else it must be the description
        } //end loop
        
        Set<Object> rowsModifiedI = new HashSet<>();
        
        
        //NOTE  making everything new for now
//        if(2 > 1) {
//        	isNew = true;
//        }

        if (isNew == null && i == null && desc != null) { //try looking up active task by description
            Object oi = Q.cell(true, "select i from do_log where end = 'in_progress' and desc = ?", desc);
            if (oi != null) {
                isNew = false;
                i = new Integer(oi.toString());
            } else {
                isNew = true;
            }
        }
        if (isNew == null) { throw new RuntimeException("assertion failed"); }
        if (isNew) {
            if ( ! allowParallel) { //end existingtasks
                List<Object> toEnd = Q.column("select i from do_log where end = 'in_progress'");
                rowsModifiedI.addAll(toEnd);
                for(Object endI : toEnd) {
                    Q.sqlMod("update do_log set end = ? where i = ?", B.sqlite(new Date()), endI);
                }
            }
            startTs = startTs != null ? startTs : new Timestamp(System.currentTimeMillis());
            pct = pct != null ? pct : 1F;
            i = new Integer(Q.cell("select max(i) + 1 from do_log").toString());
            rowsModifiedI.add(i);
            Q.sqlMod("insert into do_log (i) values (?)", i);
        }
        if (i != null) {
            rowsModifiedI.add(i);
            if (desc != null) {
                Q.sqlMod("update do_log set desc = ?, pubcat = ? where i = ?", desc, TimeTrackingCommand.dadcat(desc), i);
            } else { if(isNew){ throw new RuntimeException("blank description/category!!! args left:"+args);} }
            if (startTs != null) {
                Q.sqlMod("update do_log set start = ? where i = ?", B.sqlite(startTs), i);
            }
            if (endTs != null) {
                Q.sqlMod("update do_log set end = ? where i = ?", B.sqlite(endTs), i);
            } else if (isNew) {
                Q.sqlMod("update do_log set end = 'in_progress' where i = ?", i); //special case here because we have a datatype mismatch allowed by SQLite but not Java (unless we just used Object of course)
            }
            if (pct != null) {
                Q.sqlMod("update do_log set intensity = ? where i = ?", pct, i);
            }
        }
        //if(!args.isEmpty()) {
        //    throw new RuntimeException("something went wrong, these parameters were not parsed properly: " + args);
        //}
        writer.println(Q.table("select * from v_do_log where i > (select max(i) - 10 from do_log) or i = ?", true, i));
        for(Object modI : rowsModifiedI) {
            writer.println("row modified>>>>> "+Q.row("select * from v_do_log where i = ?", modI));
        }
        sopInProgress();
    }


    static String dadcat(String desc) {
			return B.group(1, B.getPatternI("^(.*?)(#|:| |$)"), desc);
	}

	/**
	 * deprecated - review and delete
	 * 
	 */
	protected void sopInProgressOld() {
        final List<List<Object>> inProgress = Q.table("select * from v_do_log where end = 'in_progress'", false);
        if (!inProgress.isEmpty()) {
            sop("in progress........................");
            sop(inProgress);
        } else {
            sop("no active tasks");
        }
    }
    private void sopInProgress() {
        final List<List<Object>> inProgress = Q.table("select * from v_do_log where i > (select max(i) - 30 from v_do_log)", false);
        sop(inProgress);
    }

}
