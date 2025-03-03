# **Splat Expressions in Python**

A **splat expression** in Python is represented using the `*` (single asterisk) and `**` (double asterisk) operators. It allows you to unpack iterables (lists, tuples, dictionaries) into function arguments, new sequences, or dictionary updates.

---

## **1. Types of Splat Expressions**

### **(A) Single Asterisk (`*`)**

- Used for **iterable unpacking** (lists, tuples, sets).
- Works in **function arguments** and **list/tuple unpacking**.

### **(B) Double Asterisk (`**`)\*\*

- Used for **dictionary unpacking**.
- Works with **function arguments** (passing keyword arguments) and **merging dictionaries**.

---

## **2. Examples of Splat Expressions**

### **(A) Using `*` for Function Arguments**

The `*` operator unpacks iterables (like lists/tuples) into separate arguments when calling a function.

#### **Example 1: Passing List Elements as Arguments**

```python
def add(a, b, c):
    return a + b + c

numbers = [2, 3, 5]
result = add(*numbers)  # Unpacks the list elements
print(result)  # Output: 10
```

#### **Example 2: Collecting Arguments with `*` (Variadic Functions)**

```python
def sum_all(*args):
    return sum(args)

print(sum_all(1, 2, 3, 4, 5))  # Output: 15
```

---

### **(B) Using `*` to Unpack Iterables**

#### **Example 3: List Unpacking in Assignment**

```python
first, *middle, last = [10, 20, 30, 40, 50]
print(first)   # Output: 10
print(middle)  # Output: [20, 30, 40]
print(last)    # Output: 50
```

#### **Example 4: Merging Lists with `*`**

```python
list1 = [1, 2, 3]
list2 = [4, 5, 6]
merged_list = [*list1, *list2]
print(merged_list)  # Output: [1, 2, 3, 4, 5, 6]
```

---

### **(C) Using `**` for Dictionary Unpacking\*\*

#### **Example 5: Passing Dictionary as Function Arguments**

```python
def greet(name, age):
    print(f"Hello, my name is {name} and I am {age} years old.")

person = {"name": "Alice", "age": 25}
greet(**person)
# Output: Hello, my name is Alice and I am 25 years old.
```

#### **Example 6: Merging Dictionaries with `**`\*\*

```python
dict1 = {"a": 1, "b": 2}
dict2 = {"c": 3, "d": 4}
merged_dict = {**dict1, **dict2}
print(merged_dict)  # Output: {'a': 1, 'b': 2, 'c': 3, 'd': 4}
```

---

### **(D) Combining `*` and `**` in Functions\*\*

#### **Example 7: Using `*args` and `**kwargs`\*\*

```python
def display_info(*args, **kwargs):
    print("Positional arguments:", args)
    print("Keyword arguments:", kwargs)

display_info(1, 2, 3, name="John", age=30)
```

**Output:**

```
Positional arguments: (1, 2, 3)
Keyword arguments: {'name': 'John', 'age': 30}
```

---

## **3. Summary**

| Operator   | Use Case                                 | Example                            |
| ---------- | ---------------------------------------- | ---------------------------------- |
| `*`        | Unpacking lists/tuples in function calls | `func(*[1,2,3])`                   |
| `*args`    | Collect multiple positional arguments    | `def func(*args):`                 |
| `*`        | List unpacking in assignment             | `first, *middle, last = [1,2,3,4]` |
| `*`        | Merging lists                            | `[ *list1, *list2 ]`               |
| `**`       | Unpacking dictionary in function calls   | `func(**{'a':1, 'b':2})`           |
| `**kwargs` | Collect multiple keyword arguments       | `def func(**kwargs):`              |
| `**`       | Merging dictionaries                     | `{**dict1, **dict2}`               |

---

Would you like me to add more details or specific use cases? 🚀
