
### 📘 Terraform `plan -out` Option Explained

When you run Terraform, you often use the following commands:

```bash
terraform plan
terraform apply
```

---

## ⚠️ The Warning Message

When you run:

```bash
terraform plan
```

You may see this message:

> **Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.**

---

## 🎯 What Does It Mean?

Terraform is telling you:

- It generated a **plan** of what it wants to do (e.g., create resources).
- But since you didn’t **save** the plan, Terraform can’t **guarantee** the apply step will do **exactly the same thing**.

Why? Because if something changes (infrastructure state, variables, etc.) between `plan` and `apply`, Terraform will **recalculate** the plan and might do something different.

---

## ✅ How to Fix: Use `-out`

To save the plan to a file:

```bash
terraform plan -out=tfplan
```

This writes the plan to a file called `tfplan`.

Then you can apply that exact plan:

```bash
terraform apply tfplan
```

This ensures **only** the planned changes are applied.

---

## 🛡️ Why This Matters

- Infrastructure or code might change between `plan` and `apply`.
- Time-sensitive or dynamic resources (e.g., timestamps, random) might behave differently.
- Saved plan files are important for **automation**, **auditing**, and **CI/CD** pipelines.

---

## 🧾 Summary Table

| Command                    | Description                                               |
|---------------------------|-----------------------------------------------------------|
| `terraform plan`          | Shows the plan (not saved)                                |
| `terraform plan -out=xyz` | Saves the plan to file `xyz`                              |
| `terraform apply`         | Recalculates the plan before applying                     |
| `terraform apply xyz`     | Applies exactly what was in the saved plan file `xyz`     |

---

Let me know if you'd like an example project with this flow.
