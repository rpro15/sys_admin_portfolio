# Pre-Publish Checklist

Quick checklist before making the repository public.

## 1. Secrets and placeholders

- [ ] Replace `SET_VIA_ANSIBLE_VAULT_OR_ENV` in `ansible/inventory.ini` with local secret handling
- [ ] Replace `YOUR_UNLISTED_VIDEO_ID` in `demo/README.md`
- [ ] Replace `SET_STRONG_PASSWORD_PER_USER` in `examples/users.csv` or remove the `Password` column from public example

## 2. Sensitive infrastructure details

- [ ] Ensure internal hostnames/domains are generic (for example `corp.local`)
- [ ] Ensure internal IPs in screenshots are masked if required by policy
- [ ] Ensure no real server names or asset IDs are exposed

## 3. Evidence quality

- [ ] Add 2-3 final screenshots to `docs/screenshots/`
- [ ] Export final PDFs:
- [ ] `backup/test-restore-report.pdf`
- [ ] `docs/service-visit-report-example.pdf`
- [ ] Verify all screenshot links render correctly in `README.md`

## 4. Portfolio readability

- [ ] Ensure `README.md` has up-to-date structure and links
- [ ] Ensure demo steps in `demo/README.md` match actual video sequence
- [ ] Read repository once as an interviewer: can key value be understood in 2-3 minutes?

## 5. Final git sanity check

- [ ] Run `git status` and confirm no accidental files are staged
- [ ] Review diff for sensitive data before commit/push
