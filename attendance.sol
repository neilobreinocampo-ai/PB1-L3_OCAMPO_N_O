// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AttendanceRecord {
    address public instructor; 
    string public courseTitle; 

    mapping(address => bool) public hasAttended; 
    address[] public attendees; 

    event AttendanceRecorded(address indexed student, uint256 timestamp); 
    event AttendanceRemoved(address indexed student); //this log when someone is removed from the list

    constructor(string memory _courseTitle) {
        instructor = msg.sender;
        courseTitle = _courseTitle;
    }

    modifier onlyInstructor() {
        require(msg.sender == instructor, "Only the instructor can perform this action.");
        _;
    }

    function recordAttendance(address _student) external onlyInstructor {
        require(_student != address(0), "Invalid student address.");
        require(!hasAttended[_student], "Student is already recorded.");

        hasAttended[_student] = true;
        attendees.push(_student);

        emit AttendanceRecorded(_student, block.timestamp);
    }

    function getAttendeeCount() external view returns (uint256) {
        return attendees.length;
    }

    function isAttending(address _student) external view returns (bool) {
        return hasAttended[_student];
    }

    //this is for when a teacher removes a student if they need to be cleared
    function removeAttendance(address _student) external onlyInstructor {
        require(hasAttended[_student], "Student is not currently marked present.");

        hasAttended[_student] = false;

        emit AttendanceRemoved(_student);
    }
}