# Contributing to TradeLeague

Thank you for your interest in contributing to TradeLeague! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Process](#development-process)
4. [Code Standards](#code-standards)
5. [Testing Guidelines](#testing-guidelines)
6. [Pull Request Process](#pull-request-process)
7. [Issue Guidelines](#issue-guidelines)
8. [Community](#community)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. Please be respectful and constructive in all interactions.

### Expected Behavior

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on what is best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment, discrimination, or exclusionary behavior
- Trolling, insulting comments, or personal attacks
- Publishing others' private information
- Other conduct which could reasonably be considered inappropriate

---

## Getting Started

### 1. Fork the Repository

```bash
# Click "Fork" on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/TradeLeague.git
cd TradeLeague
```

### 2. Set Up Development Environment

Follow the [Setup Guide](SETUP.md) to configure your local development environment.

### 3. Create a Branch

```bash
git checkout -b feature/your-feature-name
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Test additions or modifications

---

## Development Process

### 1. Pick an Issue

- Browse [open issues](https://github.com/ellisosborn03/TradeLeague/issues)
- Look for issues labeled `good first issue` or `help wanted`
- Comment on the issue to let others know you're working on it

### 2. Develop Your Changes

```bash
# Make your changes
# Test your changes locally
# Ensure all tests pass
npm test

# Ensure code style is correct
npm run lint
npm run format
```

### 3. Commit Your Changes

Follow conventional commit format:

```
type(scope): subject

body (optional)

footer (optional)
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Test additions or modifications
- `chore`: Build process or auxiliary tool changes

**Examples:**
```bash
git commit -m "feat(leagues): add prize pool distribution"
git commit -m "fix(auth): resolve token expiration issue"
git commit -m "docs(api): add prediction market endpoints"
```

### 4. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 5. Create Pull Request

Go to the original repository and create a pull request from your branch.

---

## Code Standards

### TypeScript/JavaScript

#### Style Guide

```typescript
// ✅ Good
interface User {
  id: string;
  walletAddress: string;
  username: string;
}

async function fetchUser(userId: string): Promise<User> {
  const response = await api.get(`/users/${userId}`);
  return response.data;
}

// ❌ Bad
interface user {
  ID: string;
  wallet_address: string;
  UserName: string;
}

async function getUser(id: string) {
  const res = await api.get('/users/' + id);
  return res.data;
}
```

#### Best Practices

- **Use TypeScript** for type safety
- **Follow ESLint rules** - Run `npm run lint`
- **Prefer `const` over `let`** - Immutability
- **Use async/await** over callbacks
- **Destructure objects** for cleaner code
- **Use meaningful variable names**
- **Add JSDoc comments** for public functions

```typescript
/**
 * Fetches user profile by ID
 * @param userId - Unique user identifier
 * @returns User profile data
 * @throws {ApiError} If user not found
 */
async function fetchUserProfile(userId: string): Promise<UserProfile> {
  // implementation
}
```

### Swift

#### Style Guide

```swift
// ✅ Good
struct User {
    let id: String
    let walletAddress: String
    let username: String
}

func fetchUser(userId: String) async throws -> User {
    let response = try await api.get("/users/\(userId)")
    return try JSONDecoder().decode(User.self, from: response)
}

// ❌ Bad
struct user {
    var ID: String
    var wallet_address: String
    var UserName: String
}

func getUser(id: String) -> User? {
    // implementation
}
```

#### Best Practices

- **Follow Swift API Design Guidelines**
- **Use SwiftLint** - Run `swiftlint`
- **Prefer `let` over `var`** - Immutability
- **Use meaningful names** - Clear and descriptive
- **Add documentation comments**
- **Handle errors properly** - Use `throws` and `Result`

### Move

#### Style Guide

```move
// ✅ Good
module tradeleague::league_manager {
    struct League has key {
        name: String,
        entry_fee: u64,
        participants: vector<address>
    }

    public entry fun create_league(
        creator: &signer,
        name: String,
        entry_fee: u64
    ) acquires League {
        // implementation
    }
}

// ❌ Bad
module tradeleague::leaguemanager {
    struct league has key {
        Name: String,
        entryFee: u64,
        Participants: vector<address>
    }
}
```

#### Best Practices

- **Follow Move conventions**
- **Use snake_case** for functions and variables
- **Document public functions**
- **Test all functions** - Use `#[test]`
- **Handle errors** - Use `assert!` appropriately
- **Optimize gas usage** - Minimize storage operations

---

## Testing Guidelines

### Unit Tests

All new features should include unit tests.

**JavaScript/TypeScript:**
```typescript
describe('UserService', () => {
  describe('fetchUser', () => {
    it('should fetch user by ID', async () => {
      const user = await userService.fetchUser('123');
      expect(user.id).toBe('123');
    });

    it('should throw error for invalid ID', async () => {
      await expect(userService.fetchUser('invalid'))
        .rejects
        .toThrow('User not found');
    });
  });
});
```

**Swift:**
```swift
class UserServiceTests: XCTestCase {
    func testFetchUser() async throws {
        let user = try await userService.fetchUser(userId: "123")
        XCTAssertEqual(user.id, "123")
    }

    func testFetchUserInvalidId() async {
        do {
            _ = try await userService.fetchUser(userId: "invalid")
            XCTFail("Expected error to be thrown")
        } catch {
            // Expected
        }
    }
}
```

**Move:**
```move
#[test(creator = @tradeleague)]
fun test_create_league(creator: &signer) {
    league_manager::create_league(
        creator,
        string::utf8(b"Test League"),
        100
    );

    let league = borrow_global<League>(signer::address_of(creator));
    assert!(league.entry_fee == 100, 0);
}
```

### Integration Tests

Test API endpoints and user flows.

```typescript
describe('POST /leagues/:id/join', () => {
  it('should allow user to join league', async () => {
    const response = await request(app)
      .post('/api/v1/leagues/123/join')
      .set('Authorization', `Bearer ${token}`)
      .send({ acceptRules: true });

    expect(response.status).toBe(201);
    expect(response.body.leagueId).toBe('123');
  });
});
```

### Test Coverage

- **Minimum coverage**: 80%
- **Critical paths**: 100% coverage
- Run coverage: `npm run test:coverage`

---

## Pull Request Process

### 1. PR Title

Use conventional commit format:
```
feat(leagues): add prize pool distribution
fix(auth): resolve token expiration bug
docs(api): add prediction market endpoints
```

### 2. PR Description

Include:

```markdown
## Description
Brief description of changes

## Motivation
Why is this change needed?

## Changes
- Change 1
- Change 2

## Testing
How was this tested?

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Tests pass locally
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Self-review completed
```

### 3. Review Process

1. **Automated checks** must pass
   - Linting
   - Tests
   - Build

2. **Code review** by maintainers
   - At least 1 approval required
   - Address all comments

3. **Merge** by maintainer
   - Squash and merge
   - Delete branch after merge

### 4. After Merge

- Pull latest main: `git pull upstream main`
- Delete local branch: `git branch -d feature/your-feature`

---

## Issue Guidelines

### Creating Issues

**Bug Report:**
```markdown
### Description
Clear description of the bug

### Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

### Expected Behavior
What should happen

### Actual Behavior
What actually happens

### Environment
- Device: iPhone 14 Pro
- iOS: 16.5
- App version: 1.0.0

### Screenshots
Add screenshots if applicable
```

**Feature Request:**
```markdown
### Feature Description
Clear description of the feature

### Motivation
Why is this feature needed?

### Proposed Solution
How should this work?

### Alternatives Considered
Other approaches considered

### Additional Context
Any other relevant information
```

### Issue Labels

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Documentation improvements
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `question` - Further information requested
- `wontfix` - This will not be worked on

---

## Community

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and ideas
- **Twitter**: [@0xTradingLeague](https://twitter.com/0xTradingLeague)
- **Email**: contribute@tradeleague.io

### Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Invited to contributor channel

### Office Hours

- **Weekly Dev Call**: Tuesdays 2pm UTC
- **Community Call**: First Friday of month, 3pm UTC

Join via link in GitHub Discussions.

---

## Financial Contributions

TradeLeague is currently not accepting financial contributions. The best way to support the project is through code contributions and community engagement.

---

## Questions?

If you have questions:

1. Check [documentation](/)
2. Search [existing issues](https://github.com/ellisosborn03/TradeLeague/issues)
3. Ask in [GitHub Discussions](https://github.com/ellisosborn03/TradeLeague/discussions)
4. Reach out on [Twitter](https://twitter.com/0xTradingLeague)

---

Thank you for contributing to TradeLeague! 🚀

**Last Updated**: October 2025
