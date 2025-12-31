# 📘 How to Switch to a Specific SVN Revision in a Local Working Copy

This guide explains how to update your existing local SVN working copy to match a specific revision number. This is useful for testing, debugging, or reviewing the project as it existed at a certain point in history.

---

## 🧠 Core Concepts

- **SVN Working Copy:** Your local folder containing files checked out from the SVN repository.
- **Revision Number:** A unique number assigned to each commit in SVN.
- **svn update -r REV_NUMBER:** The command to update your local copy to a specific revision.

---

## 🛠️ How to Use It (Step-by-Step)

1. **Open a terminal** and navigate to your local SVN working copy:

   ```bash
   cd /path/to/your/working-copy
   ```

2. **Update to a specific revision:**

   ```bash
   svn update -r REV_NUMBER
   ```

   - Replace `REV_NUMBER` with the desired revision (e.g., `svn update -r 1234`).

3. **Verify your revision:**

   ```bash
   svn info
   ```

   - This shows the current revision and repository URL.

---

## 💡 Practical Example

```bash
cd ~/projects/my-svn-repo
svn update -r 1500
svn info
```

*This updates your local copy to revision 1500 and confirms the change.*

---

## ✅ Best Practices

- Always commit or stash your local changes before switching revisions to avoid conflicts.
- Use `svn info` to confirm your current revision.
- Remember: Updating to an old revision is safe and reversible—just update again to the latest revision when done.

---

## ⚠️ Common Pitfalls & Warnings

- **Uncommitted changes may cause conflicts** when updating to a different revision.
- **Do not make commits while on an old revision** unless you know what you’re doing; this can create confusing history.
- **Always double-check your working copy path** before running update commands.

---

## 📂 Related Files & Further Learning

- Workspace files:  
  `${workspaceFolder}/.svn/`

- External resources:  
  <https://svnbook.red-bean.com/en/1.7/svn.ref.svn.c.update.html>
  <https://subversion.apache.org/docs/>

---
