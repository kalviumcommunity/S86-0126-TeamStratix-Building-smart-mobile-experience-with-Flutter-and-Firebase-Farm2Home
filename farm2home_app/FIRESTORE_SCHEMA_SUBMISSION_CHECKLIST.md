# 🎯 Firestore Schema Design - Submission Checklist

## Sprint 2: Cloud Firestore Database Schema Design

---

## 📋 Implementation Checklist

### Schema Design
- [x] ✅ Identified data requirements for Farm2Home app
- [x] ✅ Designed top-level collections (users, farmers, products, orders, categories, notifications)
- [x] ✅ Designed subcollections (addresses, reviews, order updates)
- [x] ✅ Defined document structure with fields and data types
- [x] ✅ Used proper naming conventions (lowerCamelCase)
- [x] ✅ Added timestamps (createdAt, updatedAt) to all collections
- [x] ✅ Made design decisions on subcollections vs arrays
- [x] ✅ Planned for scalability (handle thousands of records)

### Documentation
- [x] ✅ Created comprehensive schema document (FIRESTORE_SCHEMA.md)
- [x] ✅ Created visual schema diagrams (FIRESTORE_SCHEMA_DIAGRAM.md)
- [x] ✅ Updated README with schema overview
- [x] ✅ Included sample JSON documents for each collection
- [x] ✅ Documented design decisions and justifications
- [x] ✅ Added reflection on challenges and learnings
- [x] ✅ Provided common query examples

### Diagrams
- [x] ✅ Created Mermaid diagram showing structure
- [x] ✅ Created ER-style relationship diagram
- [x] ✅ Created ASCII data flow diagram
- [x] ✅ Documented collection relationships
- [x] ✅ Showed subcollection hierarchy

---

## 📝 README Content Checklist

Your README now includes:

- [x] ✅ Project title and overview
- [x] ✅ Data requirements list
- [x] ✅ Complete Firestore schema structure
- [x] ✅ Collection details with fields and types
- [x] ✅ Sample JSON documents
- [x] ✅ Schema diagram references
- [x] ✅ Key design decisions explained
- [x] ✅ Query examples
- [x] ✅ Performance & scalability considerations
- [x] ✅ Reflection section
- [x] ✅ Links to detailed documentation

---

## 🎥 Video Demo Requirements (1-2 minutes)

Your video should demonstrate:

### Introduction (0:00-0:15)
> "Hello, I'm presenting the Firestore database schema design for Farm2Home, a farm-to-consumer marketplace application."

### Schema Overview (0:15-0:40)
> "The schema consists of 6 top-level collections..."
- Show schema structure (README or diagram)
- Point out main collections: users, farmers, products, orders, categories, notifications

### Key Design Decisions (0:40-1:00)
> "Here are the key design decisions we made..."
- Explain why subcollections for reviews, addresses, order updates
- Show sample document structure
- Mention scalability considerations

### Diagram Walkthrough (1:00-1:30)
> "This diagram shows how the collections relate to each other..."
- Display visual schema diagram
- Point out relationships (users → orders, products → reviews)
- Show data flow

### Firebase Console (Optional but Recommended) (1:30-1:45)
> "In the Firebase Console, we can see the collections..."
- Open Firebase Console
- Navigate to Firestore Database
- Show any collections you've created
- Demonstrate structure matches schema

### Conclusion (1:45-2:00)
> "This schema provides a scalable, efficient foundation for the Farm2Home app, supporting real-time updates and complex queries."

---

## 📁 Files to Include in PR

### Created Files
- [x] ✅ `FIRESTORE_SCHEMA.md` - Detailed schema documentation
- [x] ✅ `FIRESTORE_SCHEMA_DIAGRAM.md` - Visual diagrams
- [x] ✅ `FIRESTORE_SCHEMA_SUBMISSION_CHECKLIST.md` - This checklist

### Modified Files
- [x] ✅ `README.md` - Added Firestore schema section

---

## 🚀 Pull Request Guidelines

### Commit Message
```bash
git add .
git commit -m "feat: designed Firestore schema and added database diagram"
git push origin your-branch-name
```

### PR Title
```
[Sprint-2] Firestore Database Schema Design – YourTeamName
```

### PR Description Template

```markdown
## Firestore Database Schema Design

### Overview
Designed a comprehensive Firestore database schema for Farm2Home, a farm-to-consumer marketplace. The schema includes 6 top-level collections and 3 subcollections, optimized for scalability and performance.

### Collections Designed

**Top-Level Collections:**
1. **users** - Customer profiles and preferences
2. **farmers** - Vendor/farm profiles with location and certifications
3. **products** - Farm products with pricing, inventory, and ratings
4. **orders** - Purchase history and order tracking
5. **categories** - Product categorization
6. **notifications** - User notifications for orders and promotions

**Subcollections:**
1. **users/{userId}/addresses** - Multiple delivery addresses per user
2. **products/{productId}/reviews** - Customer reviews and ratings
3. **orders/{orderId}/updates** - Order status tracking timeline

### Key Design Decisions

✅ **Subcollections for Scalability**
- Reviews can grow to thousands per product
- Addresses loaded only when needed
- Order updates maintain complete audit trail

✅ **Top-Level Orders Collection**
- Enables cross-user queries for admin dashboard
- Supports farmer view of orders containing their products
- Facilitates analytics and reporting

✅ **Smart Denormalization**
- Product names stored in order items for accurate history
- User names in reviews for fast display
- Trade-off: Controlled duplication for read performance

✅ **Proper Field Naming**
- lowerCamelCase throughout
- Boolean fields prefixed with `is`
- Consistent timestamp fields (createdAt, updatedAt)

### Sample Document (Products)

```json
{
  "productId": "prod_001",
  "name": "Organic Tomatoes",
  "description": "Fresh, vine-ripened organic tomatoes",
  "farmerId": "farm_456",
  "category": "Vegetables",
  "price": 3.99,
  "unit": "lb",
  "stockQuantity": 150,
  "isAvailable": true,
  "imageUrls": ["https://..."],
  "tags": ["organic", "local", "seasonal"],
  "rating": 4.7,
  "totalReviews": 45,
  "createdAt": "2026-02-06T10:00:00Z",
  "updatedAt": "2026-02-06T10:00:00Z"
}
```

### Schema Diagrams

Complete visual diagrams included in:
- `FIRESTORE_SCHEMA_DIAGRAM.md` - Mermaid diagram, ER diagram, data flow

See README for full schema documentation.

### Performance Considerations

- ✅ Subcollections prevent document size limits
- ✅ Indexed fields for efficient queries
- ✅ Denormalization reduces reads
- ✅ Real-time optimized for live updates
- ✅ Supports pagination for large datasets

### Scalability

Schema designed to handle:
- Thousands of products
- Millions of users
- Unlimited orders (growing over time)
- Hundreds of reviews per product
- Multiple addresses per user

### Reflection

**Why This Structure?**
- Separation of concerns with independent collections
- Query efficiency through smart denormalization
- Scalability via subcollections
- Real-time ready with small, focused documents

**Challenges Faced:**
- Deciding when to use subcollections vs arrays
- Balancing denormalization (speed) vs normalization (consistency)
- Firestore query limitations (no OR queries)

**What I Learned:**
- NoSQL requires different thinking than SQL
- Design schema around query patterns
- Subcollections are essential for large datasets
- Denormalization is acceptable in moderation

### Documentation

- **Detailed Schema**: `FIRESTORE_SCHEMA.md`
- **Visual Diagrams**: `FIRESTORE_SCHEMA_DIAGRAM.md`
- **README Section**: Complete overview with examples

### Video Demo

[Link to video demo showing schema design and Firebase Console]

### Testing in Firebase Console

[Optional: Screenshot of Firestore collections in Firebase Console]

---

**Ready for Review** ✅
```

---

## 🎬 Video Recording Tips

### Setup
1. Open README.md to show schema overview
2. Open FIRESTORE_SCHEMA_DIAGRAM.md for visual diagrams
3. Have Firebase Console ready (optional)
4. Prepare screen recording software

### Recording Checklist
- [ ] Clear audio (use good microphone)
- [ ] Screen resolution readable (1920x1080 recommended)
- [ ] No personal information visible
- [ ] 1-2 minutes total length
- [ ] Narration explaining each section
- [ ] Professional tone

### Upload & Share
- [ ] Upload to Google Drive / Loom / YouTube (unlisted)
- [ ] Set permissions: "Anyone with the link (Edit)"
- [ ] Test link in incognito/private browser
- [ ] Copy link for PR description

---

## ✅ Validation Checklist

Before submitting, verify:

### Schema Quality
- [ ] All collections have clear purpose
- [ ] Field names follow lowerCamelCase convention
- [ ] Data types are appropriate (string, number, boolean, array, map, timestamp)
- [ ] Timestamps added to all collections (createdAt, updatedAt)
- [ ] Subcollections used appropriately for large datasets
- [ ] References stored as string IDs (not full objects)

### Documentation Quality
- [ ] README has complete schema section
- [ ] Sample documents provided for each collection
- [ ] Design decisions explained
- [ ] Diagrams are clear and readable
- [ ] Reflection section completed
- [ ] Links to detailed docs work

### Scalability
- [ ] Schema can handle thousands of records
- [ ] No arrays that could grow unbounded
- [ ] Document sizes stay under 1MB limit
- [ ] Queries are efficient (indexed fields)
- [ ] Subcollections used for large datasets

### Professionalism
- [ ] No typos in documentation
- [ ] Consistent formatting
- [ ] Professional diagrams
- [ ] Clear explanations
- [ ] Complete reflection

---

## 🎯 Success Criteria

Your schema design is complete when:

✅ **Structure is Clear**
- 6+ top-level collections defined
- 3+ subcollections where appropriate
- All fields documented with types

✅ **Documentation is Complete**
- README has schema section
- Detailed schema document exists
- Visual diagrams provided
- Sample documents included

✅ **Design is Justified**
- Subcollection decisions explained
- Denormalization choices justified
- Performance considerations noted
- Scalability addressed

✅ **Professional Presentation**
- Clean, readable diagrams
- Consistent naming conventions
- Reflection completed
- Video demo recorded

---

## 📚 Resources

- [Firestore Data Modeling Guide](https://firebase.google.com/docs/firestore/manage-data/structure-data)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)
- [NoSQL vs SQL](https://www.mongodb.com/nosql-explained/nosql-vs-sql)
- [Mermaid Diagram Syntax](https://mermaid.js.org/syntax/flowchart.html)

---

## 🏆 Bonus Points (Optional)

Consider adding:

- [ ] Firebase Security Rules examples
- [ ] Cloud Functions triggers for the schema
- [ ] Composite index definitions
- [ ] Data migration plan
- [ ] Backup strategy

---

**Team Name**: _________________

**Submission Date**: _________________

**PR Link**: _________________

**Video Link**: _________________

---

**Status**: ✅ READY TO SUBMIT

Good luck! Your Firestore schema is well-designed and thoroughly documented! 🚀
